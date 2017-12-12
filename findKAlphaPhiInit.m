function kAlphaPhiInit = findKAlphaPhiInit(v, xy, LB_UB, params)
%
%   kALphaPhiInit = findKAlphaInitPhi(v, xy, LB_UB, params);
%
%  find appropriate wavenumber and direction estimates, k and alpha
%  based on the phase structure of the first EOF, v, at locations, xy.  
%  The estimate is done by modeling phase difference versus x and y
%  difference. dTheta = kx*dx + ky*dy.  This is done by extracting an x and 
%  y transect of phase and finding the median dPhasedx etc to remove phase
%  jumps.  This is done at multiple transects, taking the median of the
%  results. 

sliceFract = 0.1;   % define slices a this fraction nearest location
N = size(xy,1);
n = floor(sliceFract*N);
[~, ind] = sort(xy(:,2));       % sort everything in order of y
x = xy(ind,1);
phase = angle(v(ind));

% find kx estimate at n longshore locations then find median
for i = 1: floor(N/n)
    pick = [(i-1)*n+1: i*n];
    [xp, xpInd] = sort(x(pick));
    phz = phase(pick(xpInd));
    kx(i) = median(diff(phz(:))./diff(xp(:)));
end
kx = median(kx);

% now find ky estimate at n cross-shore locations then find median
[~, ind] = sort(xy(:,1));       % sort everything in order of x
y = xy(ind,2);
phase = angle(v(ind));
for i = 1: floor(N/n)
    pick = [(i-1)*n+1: i*n];
    [yp, ypInd] = sort(y(pick));
    phz = phase(pick(ypInd));
    ky(i) = median(diff(phz(:))./diff(yp(:)));
end
ky = median(ky);
kVec = kx+1i*ky;
k = abs(kVec); 
alpha = angle(kVec)-pi;     % switch by pi for 'coming from' angle
phi = mean(rem(phase - kx*xy(:,1) - ky*xy(:,2), 2*pi));

if ((k<LB_UB(1,1)) || (k>LB_UB(2,1)))    % if not in expected range
    k = dispsol(3.0, 0.1, 0);           % just guess a 0.1 Hz, h=3m value.
end

kAlphaPhiInit = [k alpha phi];


% Copyright by Oregon State University, 2017
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: findKAlphaPhiInit.m 4 2016-02-11 00:35:38Z  $
%
% $Log: findKAlphaPhiInit.m,v $
% Revision 1.1  2012/09/24 23:20:22  stanley
% Initial revision
%
% Revision 1.1  2011/08/08 00:28:51  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
