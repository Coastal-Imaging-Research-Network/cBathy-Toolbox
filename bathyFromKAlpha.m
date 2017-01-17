function bathy = bathyFromKAlpha(bathy)
%
%  bathy = bathyFromKAlpha(bathy);
% 
% final step in BWLite to take multi-frequency estimates of bathymetry
% and find a best solution for each tomographic location using skill
% and error weightings

OPTIONS = statset('nlinfit');   % nlinfit options
OPTIONS.MaxIter = 30;
OPTIONS.TolX = 1e-10; %%%1e-3;l
OPTIONS.Display = 'iter';
OPTIONS.Display = 'off';

g = 9.81; % gravity, it's the law!
ri = [0:0.01:1]';       % create a hanning filter for later interp
ai = (1 - cos( pi*(0.5 + 0.5*ri) ).^2);

%%lines 18-24, create sensitivity vectors gammaiBar and mu
% find the dispersion sensitivity, mu.  This will used to interp into
% gammi, mu, below.
gammai = [0.0: 0.01: 1];
gammaiBar = (gammai(1:end-1)+gammai(2:end))/2;
foo = gammai.*atanh(gammai);
dFoodGamma = diff(foo)./diff(gammai);
mu = dFoodGamma./tanh(gammaiBar);

params = bathy.params;
nFreqs = size(bathy.fDependent.fB, 3);
x = bathy.xm; y = bathy.ym;     % for ease of writing
xMin = min(x);
xMax = max(x);
X = repmat(x, [size(y,2), 1, nFreqs]);
Y = repmat(y', [1, size(x,2), nFreqs]);

% loop through all points, doing nlinfit solution for h.  Note that the init
% values of nan are returned unless solution is successful.
for ix = 1: length(x)
    for iy = 1: length(y)
        kappa = 1 + (bathy.params.kappa0-1)*(x(ix) - xMin)/ ...
        (xMax - xMin);
        % find range-based weights, Wmi to contribute to total weight
        dxmi = X - x(ix);
        dymi = Y - y(iy);
        r = sqrt((dxmi/(params.Lx*kappa)).^2 + (dymi/(params.Ly*kappa)).^2);
        Wmi = interp1(ri,ai,r,'linear*',0);  % sample normalized weights

        id = find((Wmi > 0) & ...
                  (bathy.fDependent.skill>params.QTOL) & ...
                   (~isnan(bathy.fDependent.hTemp)));
        if(length(id)>params.minValsForBathyEst)                % just need two
            f = bathy.fDependent.fB(id);
            k = bathy.fDependent.k(id);
	    kErr = bathy.fDependent.kErr(id);
            s = bathy.fDependent.skill(id);
            l = bathy.fDependent.lam1(id);
%             % find dispersion sensitivity
             gamma = 4*pi*pi*f.*f./(g.*k);
             wMu = 1./interp1(gammaiBar, mu, gamma);
             w = Wmi(id).*wMu.*l.*s./(eps+k);    % weights depend on skill and variance (lam)
            hInit = bathy.fDependent.hTemp(id)'*s / sum(s);
            [h,resid,jacob] =nlinfit([f, w], k.*w, ...
                'kInvertDepthModel',hInit, OPTIONS);
            if (~isnan(h))      % some value returned
                hErr = bathyCI(resid,jacob, w);		 % get limits not bounds
                kModel = kInvertDepthModel(h, [f, w]);
                J = sqrt(sum(kModel.*k.*w)/(eps+sum(w.^2))); % skill
                if ((J~=0) && (h>=params.MINDEPTH))
                    bathy.fCombined.h(iy,ix) = h;
                    bathy.fCombined.hErr(iy,ix) = hErr;
                    bathy.fCombined.J(iy,ix) = J;
                end
            end
        end  % default h, hErr to nan if no successful solution.
    end	%iy
end	% ix

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: bathyFromKAlpha.m,v 1.4 2016/04/11 23:03:52 stanley Exp $
%
% $Log: bathyFromKAlpha.m,v $
% Revision 1.4  2016/04/11 23:03:52  stanley
% MAX DEPTH fix
%
% Revision 1.2  2012/09/24 23:09:59  stanley
% many revisions/updates
%
% Revision 1.1  2011/08/08 00:28:51  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
