function tide = cBathyTide( stationStr, epoch )

% function tide = cBathyTide( stationStr, epoch )
%
%  this is a prototype function to demonstrate what info needs to be
%  found to deal with tides. It's called based on the tide function
%  specified in the settings file. 
%
%  if it doesn't work for your system, you need to create one.
%
%  intermediate function to get predicted or measured tides for station
%
%  returns a struct tide with fields e (epoch of tide), zt (tide value),
%  and source ('p' for predicted, 'm' for measured, and '' for none.) 
%  zt will be NaN if there is no value (and source should be '');

% default return
tide.e = 0;
tide.zt = NaN;
tide.source = '';

%  look at station. Measured is good for argus02(a) only.
%if( strncmp( stationStr, 'argus02', 7 ) )

% changed name -- argus02a to argus02b. do same here
if( strcmp( stationStr, 'argus02b' ) )
    stationStr = 'argus02a';
end

	% try Measured
	[e,t] = DBGetMeasuredTide( stationStr, epoch );
	if isempty( e ) 
		% try predicted
		[e,t] = DBGetPredictedTide( stationStr, epoch );
		if isempty( e ) 
            % one more place to look
            try
                [e,t] = getXtideTide( stationStr, epoch );
            catch
                return; 
            end;
        end;
		tide.source = 'p';
	else
		tide.source = 'm';
	end;
		
	tide.e = e;
	tide.zt = t;
	return;

%end

% add others here when able

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

