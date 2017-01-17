function bathy = makeKalmanBathySeed(bathy)
%
%   bathy = makeKalmanBathySeed(bathy);
%
% Add sensible runningFilter values to a bathy so that it can be used
% as the seed for a running Kalman filter.

bathyNoise = 1.0^2;                 % seed variance for uncertainty
bathy.runningAverage.h = bathy.fCombined.h;     % first guess at h, hErr
bathy.runningAverage.hErr = bathy.fCombined.hErr;
bathy.runningAverage.P = repmat(bathyNoise, size(bathy.fCombined.h));
bathy.runningAverage.Q = bathy.runningAverage.P;
bathy.runningAverage.prior = 'seedBathy';

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: makeKalmanBathySeed.m,v 1.2 2012/09/24 23:26:20 stanley Exp $
%
% $Log: makeKalmanBathySeed.m,v $
% Revision 1.2  2012/09/24 23:26:20  stanley
% change to noise value
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
