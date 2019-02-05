function [subG, subXY, camUsed] = ...
        spatialLimitBathy(G, xyz, cam, xm, ym, Lx, Ly, maxNPix )

%% spatialLimitBathy -- extract appropriate data from stack for 
% [subG, subXYZ] = spatialLimitBathy( G, xyz, cam, xm, ym, Lx, Ly, maxNPix )
%
%  Take the full array of stack locations in xyz, G(nF by Nxy) and find
%  those in a tile of size Lx by Ly around and analysis point xm, ym,
%  allowing there to be a max of maxNPix.

% these are the indices of xy data that are within our box
idUse = find( (xyz(:,1) >= xm-Lx) ...
         &    (xyz(:,1) <= xm+Lx) ...
         &    (xyz(:,2) >= ym-Ly) ...
         &    (xyz(:,2) <= ym+Ly) );
 
% first decimate to maxNPix per tile, then drop minority cameras at seams.
% Otherwise you end up limited only by maxNPix and the weightings get funny
% for tiles with partial coverage.

del = max(1, length(idUse)/maxNPix);
idUse = idUse(round(1: del: length(idUse)));

subG = G(:,idUse);
subXY = xyz(idUse,1:2);
cams = cam(idUse);

% if on seam, limit to the dominant camera bypixel count
uniqueCams = unique(cams);
for i = 1: length(uniqueCams)
    N(i) = length(find(cams==uniqueCams(i)));
end

pick = [];
camUsed = -1;

if exist('N')
    [~,pickCam] = max(N);
    pick = find(cams==uniqueCams(pickCam));
    camUsed = uniqueCams(pickCam);
end
subG = subG(:,pick);   % keep only those for the majority camera
subXY = subXY(pick,:);

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

