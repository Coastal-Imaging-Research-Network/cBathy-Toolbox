function tide = findTideForCIRNDemo2023(stationStr, epoch)

% function tide = findTideForCIRNDemo2023(stationStr, epoch)
%
%  this is a proxy tide function to for CIRN bootcamp demo ONLY.  This only
%  works for two specific epoch times for argus02b. These tide values were
%  looked up manually.  This should be replaced by a read tide function for
%  real applications
%
%  returns a struct tide with fields e (epoch of tide), zt (tide value),
%  and source ('p' for predicted, 'm' for measured, and '' for none.) 
%  zt will be NaN if there is no value (and source should be '');

if (abs(epoch - 1447691340) < 600)      % close to Nov 16, 2015, 16:29 GMT
    tide.e = epoch;
    tide.zt = 0.5711;
    tide.source = 'p';
elseif (abs(epoch - 1447862340) < 600)      % close to Nov 16, 2015, 16:29 GMT
    tide.e = epoch;
    tide.zt = 0.5830;
    tide.source = 'p';
else
	tide.e = 0;
	tide.zt = nan;
    tide.source = '';
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

