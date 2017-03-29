function fDependent = ...
    csmInvertKAlpha(f, G, xyz, xm, ym, params, kappa)
%
% fCombined = ...
%   csmInvertKAlpha(f, G, xyz, xm, ym, params, kappa)
%
% estimate wavennumber components from cross spectral matrix CSM
% using local nolinear model for any provided subset of Fourier values
% at any location, xm, ym.    
%
% Input
%   f   frequencies of input Fourier coefficients, Nf x 1
%   G, Fourier coeffients from a tiles worth of pixels, Nxy x 1 (complex)
%   xyz, pixel locations (Nxy of them; z column is not required
%   xm, ym, single location for this analysis
%   params, parameters structure for analysis (from SETTINGS files)
%   kappa, spatially-variable samping domain scaling
% Outputs:
%   fDependent: small structure of results with the following fields, each
%   of length nKeep (one for each frequency)
%       - fB,       - analysed frequencies
%       - k a h,    - wavenumber, alpha, depth
%       - kEst aEst hEst - errors in wavenumber, alpha and depth
%       - skill dof, - skill and degrees of freedom

% 03/07/10 - Holman fix to catch edge error where a tomographic point
%   an extrapolation region can get poor estimates with low error
%   because only a very few pixels are fit well.  Fix is to require
%   nGood pixels (likely > 3) and to have max(deltax) and max(deltay)
%   at least wavelengthFraction of the expected wavelength.
% 09/01/11 - Holman rewrite to finally get rid of tiling and analyze a
%   single location only
% 12/05/11 - Holman major change to base on EOFs rather than direct from CSM

%% %%  1. constants and parameters

clear fDependent
g=9.81;                         % 'g'
minNeededPixels = 6;            % to avoid edge anomalies
minLFraction = 0.5;             % min fract of wavelength to span

OPTIONS = statset('nlinfit');   % fit options
OPTIONS.MaxIter = 50;
OPTIONS.TolFun = 1e-6; %%%1e-3;

Nxy = size(xyz,1); 
if Nxy<minNeededPixels          % too few points, bail out
    if( cBDebug( params ) )
        fprintf('Inadequate data to analyze tile, [x,y] = [%d, %d]\n', xm, ym)
    end;
    fDependent.k = nan(1,params.nKeep);
    return
end

ri = [0:0.01:1]';       % create a hanning filter for later interp
ai = (1 - cos( pi*(0.5 + 0.5*ri) ).^2);

%%%% 2. find basic csm for all fB frequencies, sort by total coh^2 into preferred
%%%% order and keep only nKeep frequencies
fB = params.fB;
nKeep = params.nKeep;
for i = 1: length(fB)
    id = find(abs(fB(i)-f) < (fB(2)-fB(1))/2);     % find the f's that match
    % pull out the fft data and do the cross spectrum
    C(:,:,i) = G(id,:)'*G(id,:) / length(id);   % pos 2nd leads 1st.
end

% create the coherence squared for all the potential frequence bands
coh2 = squeeze(sum(sum(abs(C)))/(size(xyz,1)*(size(xyz,1)-1)));
[~, coh2Sortid] = sort(coh2, 1, 'descend');  % sort by coh2
fs = fB(coh2Sortid(1:nKeep));         % keep only the nKeep most coherent
fDependent.fB = fs;
C = C(:,:,coh2Sortid(1:nKeep));      % ditto

% report frequencies we keep
% formatStr = repmat('%.3f ', 1, nKeep);
% fprintf(['Frequencies [' formatStr '] Hertz\n'], fs);

%% %%  3. Find lags and weightings.  NOTE that we no longer rotate
%% coordinates to a user cross-shore orientation.  The user is now
%% responsible for providing cross-shore oriented coord system.

xy = xyz(:,1:2);
% find lags xym and pixels for weighting
dxmi = xy(:,1) - repmat(xm, Nxy, 1);
dymi = xy(:,2) - repmat(ym, Nxy, 1);
r = sqrt((dxmi/(params.Lx*kappa)).^2 + (dymi/(params.Ly*kappa)).^2);
Wmi = interp1(ri,ai,r,'linear*',0);  % sample normalized weights

% find span of data in x and y to determine if sufficient
maxDx = max(max(repmat(xy(:,1),1,Nxy) - repmat(xy(:,1)',Nxy,1)));
maxDy = max(max(repmat(xy(:,2),1,Nxy) - repmat(xy(:,2)',Nxy,1)));

% calculate the distance from every point to every other point

%% %%  4. loop through frequencies from most to least coherent.  For each
%% f, find the csm, then the first EOF.  If sufficiently coherent, fit to
%% find the k, alpha and scalar phase (no lasting value).

% starting search seed for alpha (should this be ZERO after rotation?)
seedAlpha = params.offshoreRadCCWFromx;

for i = 1:nKeep         % frequency loop
    % prepare nlinfit params.  Note that k is radial wavenumber
    kmin = (2*pi*fs(i))^2/g; % smallest  and largest wavenumber
    kmax = 2*pi*fs(i)/sqrt(g*params.MINDEPTH); 
    LExpect = minLFraction*4*pi/(kmin+kmax);     % expected scale from mean k.
    LB_UB = [kmin seedAlpha-pi/2;kmax seedAlpha+pi/2];
    OPTIONS.TolX = min([kmin/1000,pi/180/1000]); % min([kmin/100,pi/180/10]);
    statset(OPTIONS);
    warning off stats:nlinfit:IterationLimitExceeded

    % info for depth subsequent h error estimation
    hiimax = 9.8*(1/fs(i)^2)/(2*pi)/2;  % deepest allowable = L0/2
    hii = [params.MINDEPTH:.1:hiimax]'; % find k for full range of h
    kii = dispsol(hii, fs(i),0);

    % pull out csm
    Cij = C(:,:,i);
    [v,d] = eig(Cij);
    lam = real(diag(d));  % order eigenvalues and remove teeny imag component
    [lam1, lamInd] = max(lam);
    lam1Norm = lam1/sum(lam)*length(lam);  % as ratio to uniform eigenvalues
    v = v(:,lamInd);           % chose only dominant EOF
    w = abs(v).*Wmi;           % final weights for fitting.
    
    % check if sufficient data quality and xy span
    if ~((lam1Norm>params.minLam) && (maxDx>LExpect) && (maxDy>LExpect))
        kAlphaPhi = [nan nan nan];
        ex = kAlphaPhi;
        skill = nan;
    else
        try
            % do nonlinear fit on surviving data
            kAlphaPhiInit = findKAlphaPhiInit(v, xy, LB_UB, params);
            [kAlphaPhi,resid,jacob] = nlinfit([xy w], [real(v); imag(v)],...
                           'predictCSM',kAlphaPhiInit, OPTIONS);
            
            % check if outside acceptable limits
            if ((kAlphaPhi(1)<LB_UB(1,1)) || (kAlphaPhi(1)>LB_UB(2,1)) ...
                    || (kAlphaPhi(2)<LB_UB(1,2)) || (kAlphaPhi(2)>LB_UB(2,2)))
                error;
            end
            
            % get predictions then skill
            vPred = predictCSM(kAlphaPhi, [xy abs(v)]);
            vPred = vPred(1:end/2) + sqrt(-1)*vPred(1+end/2:end);
            skill = 1 - norm(vPred-v)^2/norm(v-mean(v))^2; % can be neg.
            
            if( cBDebug( params, 'DOPLOTPHASETILE' ))
                figure(i); clf
                plotPhaseTile(xy,v,vPred)
                drawnow;
                fprintf('frequency %d of %d, normalized lambda %.1f\n  ', i, nKeep,lam1Norm)
            end

            % get confidence limits
            ex = nlparci(real(0*kAlphaPhi),resid,jacob); % get limits not bounds
            ex = real(ex(:,2)); % get limit, not bounds
        catch   % nlinfit failed with fatal errors, adding bogus
            kAlphaPhi = [nan nan nan];
            ex = kAlphaPhi;
            skill = nan;
            lam1 = nan;
        end % try
    end

    % store results
    fDependent.k(i) = kAlphaPhi(1); 
    fDependent.a(i) = kAlphaPhi(2);
    fDependent.dof(i) = sum(w/(eps+max(w)));  
    fDependent.skill(i) = skill;  
    fDependent.lam1(i) = lam1;
    fDependent.kErr(i) = ex(1); 
    fDependent.aErr(i) = ex(2);

    % rough estimate of depth from linear dispersion
    if ~isnan(kAlphaPhi(1))
        fDependent.hTemp(i) = interp1(kii,hii, kAlphaPhi(1));
        dhiidkii = diff(hii)./diff(kii);
        fDependent.hTempErr(i) = ...
            sqrt((interp1(kii(2:end),dhiidkii, kAlphaPhi(1))).^2.* ...
                    (ex(1).^2));
    else
        fDependent.hTemp(i) = nan;
        fDependent.hTempErr(i) = nan;
    end
end  % frequency loop

if( cBDebug( params, 'DOPLOTPHASETILE' ))
    fDependent
    input('Hit enter to continue ');
end

%
%   Copyright (C) 2017  Coastal Imaging Research Network
%                       and Oregon State University

%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.

% CIRN: https://coastal-imaging-research-network.github.io/
% CIL:  http://cil-www.coas.oregonstate.edu
%
%key cBathy
%

