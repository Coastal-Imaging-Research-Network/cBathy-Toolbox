function [xyz, epoch, data, cam] = loadBathyStack(sName, decimate)
%
%   [xyz, epoch, data, cam] = loadBathyStack(sName,decimate)
%
%  loads a bathy stack of name sName.  This routine is specific to
%  Argus protocols and should be replaced for other data sources like
%  UAVs.  The bathy stack is assumed to be of type matrix.  decimate 
%  obviously the decimation (2 means take every second point, etc)
%
% change 1: someone mixed two different 'matrix' instruments into the
%  stacks from Duck, so now I must pull out the mBW named ones myself

[stackNames, r] = loadAllStackInfo(sName);
if ~strmatch('matrix', unique([r.types]))
    error([sName ' contains no matrix instruments'])
end
ps = '';
[UV, names, xyz, cam, epoch, data, err] = ...
        loadFullInstFromStack(stackNames, r, 'matrix' );

%mine = strmatch( 'mBW', names, 'exact' );
mine = strmatch( 'mBW', names );
UV = UV(mine,:); names = names(mine); cam = cam(mine); data = data(:,mine);
xyz = xyz(mine,:);
%if (length(unique(names))>1)
%    error('Expecting only one matrix instrument mBW in stack')
%end

% load stackData      % avoid wasting time during development
foo = [1: decimate: size(data,2)]; % decimate for speed
data = data(:, foo);
xyz = xyz(foo,:);

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

