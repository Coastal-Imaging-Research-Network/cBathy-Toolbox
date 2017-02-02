nms = dir('BATHYRESULTS/argus02a/COLLECTIONRESULTS/*mat');

for i = 1: length(nms)
    eval(['load(''BATHYRESULTS/argus02a/COLLECTIONRESULTS/' nms(i).name ''');'])
    plotBathyCollectFiltered(bathy);
    figure(1); imagesc(bathy.runningAverage.K); caxis([0 1]); colorbar
    input('hit return to continue')
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

