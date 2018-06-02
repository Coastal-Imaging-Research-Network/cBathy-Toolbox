function fDependent = doQualityControlPlots(f, G, xyz, bathy)
%
%   doQualityControlPlots(f, G, xyz, bathy)
%
%  routine to show transects of coherence and phase for any specified
%  location to allow quality control checking for a data set.  The
%  routine queries for location, then solves for kAlpha then plots
%  coherence and phase info for that region.  This debug option and production
%  computation are now exclusive (you do one or the other).

params = bathy.params;
xy = input('enter [x y] for analysis, CR to exit debug - ');
x = xy(1);
y = xy(2);
if isempty(xy)
    error('Error - No x-y points selected');
    return
end
idUse = find(xyz(:,1)>=(x-params.across) ...
            & xyz(:,1)<(x+params.across) ...
            & xyz(:,2)>=(y-params.along) ...
            & xyz(:,2)<(y+params.along)); 
a = parseFilename(bathy.sName);
        
% the debug plots are contained in csmInvertKAlpha
fDependent = ...
    csmInvertKAlpha(f, G(:,idUse), xyz(idUse,:), ...
                    x, y, bathy.params);
listfDependentResultsForOnePoint(bathy, fDependent, x, y)

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

