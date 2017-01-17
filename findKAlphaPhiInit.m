function kAlphaPhiInit = findKAlphaPhiInit(v, xy, LB_UB, params)
%
%   kALphaPhiInit = findKAlphaInitPhi(v, xy, LB_UB, params);
%
%  find appropriate wavenumber and direction estimates, k and alpha
%  based on the phase structure of the first EOF, v, at locations, xy.  
%  The estimate is done at the location of the max(abs(v)) and simply finds
%  the closest point roughly the x and the y directions, then finds
%  d(angle)/dx or d(angle)/dy for kx and ky.  To keep things robust, the
%  magnitude of k is compared to the upper and lower bounds from LB_UB and
%  the seed alpha is just taken as the shore normal.  This can be improved
%  later.  Phi is a scalar phase offset for modeling the phase structure in
%  predictCSM.

penalty = 10^6;             % to keep closest search in roughly right dir.
[~, ind] = max(abs(v));     % do estimates at the most energetic point
dxy = xy - repmat(xy(ind,:),size(xy,1),1);
R2 = sum(dxy.^2,2);         % range squared
d = (1+penalty*(abs(tan(dxy(:,2)./dxy(:,1)))<(pi/6))) .*R2; % penalized distance
[~, yInd] = sort(d);        % looking for second closest point
ky = (angle(v(ind)) - angle(v(yInd(2)))) / (xy(ind,2) - xy(yInd(2),1));
d = (1+penalty*(abs(tan(dxy(:,1)./dxy(:,2)))<(pi/6))) .*R2;
[~, xInd] = sort(d);
kx = (angle(v(ind)) - angle(v(xInd(2)))) / (xy(ind,1) - xy(xInd(2),1));
kVec = kx+1i*ky;
k = abs(kVec);              % magnitude of k
alpha = params.offshoreRadCCWFromx;      % default instead of actual value.
phi = angle(v(ind)) - kx*xy(ind,1) - ky*xy(ind,2);

if ((k<LB_UB(1,1)) || (k>LB_UB(2,1)))    % if not in expected range
    k = dispsol(3.0, 0.1, 0);           % just guess a 0.1 Hz, h=3m value.
end

kAlphaPhiInit = [k alpha phi];
%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: findKAlphaPhiInit.m,v 1.1 2012/09/24 23:20:22 stanley Exp $
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
