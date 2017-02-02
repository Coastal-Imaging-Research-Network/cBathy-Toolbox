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

