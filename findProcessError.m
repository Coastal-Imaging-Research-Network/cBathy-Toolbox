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

