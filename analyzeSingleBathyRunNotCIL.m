function bathy = analyzeSingleBathyRunNotCIL(stackPnStr, stationStr)
%
%  bathy = analyzeSingleBathyRunNotCIL(stackPnStr, stationStr)
%
%  simple run of analyzeBathyCollect for a single stack.  Useful for
%  debugging.  Assumes stackPnStr is a loadable file which contains
%  variables 
%       T   - epoch times for each row in stack, Nt by 1
%       XYZ     - xyz locations for each column in stack, Nxyz by 1
%       RAW    - Nt by Nxyz matrix of cBathy stack data
%       CAM     - Nt array of camera number for associated data column.
%                 used to differentiate between data in multi-camera
%                 stacks to help with camera seams.
%
%   stationStr is the name of the station, for example 'argus02b' or
%   whatever naming convention you chose.  This name MUST correspond to a
%   callable m-file that creates the params structure that contains all of
%   the processing inputs.

eval(stationStr)        % creates the params structure.
load(stackPnStr)           % load xyz, t, data

% need an array with camera number for data
% if your stack data doesn't have it, then we have to create a dummy
%  one. 
if exist( 'CAM', 'var' ) == 0
    CAM = ones( size(XYZ,1) , 1);
end

bathy.epoch = num2str(t(1));
bathy.sName = stackPnStr;
bathy.params = params;
bathy = analyzeBathyCollect(XYZ, T, RAW, CAM, bathy);

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

