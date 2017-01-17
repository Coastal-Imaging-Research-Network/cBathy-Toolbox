function smoothBathy = KalmanFilterBathyNotCIL(priorBathy, newBathy, H)
%
%   smoothBathy = KalmanFilterBathyNotCIL(priorBathy, newBathy, H);
%
%  carries out a Kalman filter smoothing of a new Bathy collect adding
%  to a priorBathy using simple Kalman filtering.  Standard bathy
%  structures are assumed and passed along, updating the file name of
%  the prior.  Filtered data are stored in the sub-structure
%  runningAverage.  This version assumes that we are not in a CIL
%  environment.

smoothBathy = newBathy;       % a good start
hNew = newBathy.fCombined.h; 
hNewErr = newBathy.fCombined.hErr;
hPrior = priorBathy.runningAverage.h;
dt = (str2num(newBathy.epoch) - str2num(priorBathy.epoch)) / (24*3600);  % in days
Q = findProcessError(newBathy.params.stationStr, newBathy, H)*dt;
P = nansum(cat(3, priorBathy.runningAverage.P, Q),3);

% update everywhere then fix the nan problems in prior or new
K = P ./ (P + newBathy.fCombined.hErr.^2);
hSmoothed = hPrior + K.*(hNew-hPrior);
PNew = (1-K).*P;

% deal with nan's
badNew = find(isnan(hNew) | isnan(hNewErr)); % stick with hPrior
hSmoothed(badNew) = hPrior(badNew);
PNew(badNew) = P(badNew);   % pass along growing covariance

badPrior = find(isnan(hPrior));     % take new if no prior
hSmoothed(badPrior) = hNew(badPrior);
PNew(badPrior) = hNewErr(badPrior).^2;   % pass along covariance guess

% cap any runaway variances at a max value to avoid K=0 when P is huge
% Holman 01/22/12 fix for runaways.  
maxP = 10^4;
PNew(PNew > maxP) = maxP;

smoothBathy.runningAverage.h = hSmoothed;
smoothBathy.runningAverage.hErr = sqrt(PNew);
smoothBathy.runningAverage.P = PNew;
smoothBathy.runningAverage.Q = Q;
smoothBathy.runningAverage.K = K;
smoothBathy.runningAverage.prior = priorBathy.sName;

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: KalmanFilterBathy.m,v 1.2 2012/09/24 23:22:36 stanley Exp $
%
% $Log: KalmanFilterBathy.m,v $
% Revision 1.2  2012/09/24 23:22:36  stanley
% some changes?
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
