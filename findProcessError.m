function Q = findProcessError(siteStr, bathy, H)
%   Q = findProcessErrorDuck(siteString, newBathy, H);
%
%  creates a reasonable estimate of process error for Kalman
%  filtering.  For Duck, the equation was based on magnitudes of daily
%  deviation from the SandyDuck CRAB data.  For Agate it is simply a
%  similar guess

switch siteStr
    case  'argus02a'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.067;      % units /day, from 012012 re-analysis.
        x0 = 150;       % m, same calib
        sig = 100;      % m, same calib
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
    case  'argus02b'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.067;      % units /day, from 012012 re-analysis.
        x0 = 150;       % m, same calib
        sig = 100;      % m, same calib
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
    case  'batman'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.002;      % units /day, from 012012 re-analysis.
        x0 = 150;       % m, same calib
        sig = 5000;      % m, same calib
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
    case  'argus00'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.005;      % units /day, from 04/29/10 guess
        x0 = 700;       % m, same calib
        sig = 300;      % m, same calib
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
    case  'rosie'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.067;     % take Duck value randomly
        CQ = 0.02;     % change 1, 12/28/12
        x0 = 0;       % m, same calib
        sig = 5000;      % m, essentially constant values
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
    case  'droskyn'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.02;      % units /day, from total guess
        x0 = 700;       % m, same calib
        sig = 500;      % m, same calib
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
    case  'massa'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.067;     % take Duck value randomly
        x0 = 100;       % m, same calib
        sig = 100;      % m, essentially constant values
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
    case  'secret'
        X = repmat(bathy.xm, size(bathy.runningAverage.h,1), 1);
        CQ = 0.067;     % take Duck value randomly
        x0 = 100;       % m, same calib
        sig = 75;      % m, essentially constant values
        Q = CQ * H^2 * exp(-((X-x0).^2)/(2*sig*sig));
       
    otherwise
        error('No process error defined for this site, in findProcessError')
end



%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: findProcessError.m,v 1.4 2016/02/11 00:32:18 stanley Exp $
%
% $Log: findProcessError.m,v $
% Revision 1.4  2016/02/11 00:32:18  stanley
% added two sites
%
% Revision 1.3  2013/01/24 00:17:58  stanley
% changed CQ
%
% Revision 1.2  2012/09/24 23:21:23  stanley
% data for kalman filters
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
