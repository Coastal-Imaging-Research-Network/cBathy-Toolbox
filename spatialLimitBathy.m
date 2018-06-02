function [subG, subXYZ, camUsed] = spatialLimitBathy(G, xyz, cam, xm, ym, params, kappa )

%% spatialLimitBathy -- extract appropriate data from stack for 
%   processing in the vicinity of xm, ym. 
%
% [subG, subXYZ, camUsed] = spatialLimitBathy( G, xyz, cam, xm, ym, params, kappa )
%

% these are the indices of xy data that are within our box
idUse = find( (xyz(:,1) >= xm-params.Lx*kappa) ...
	 &    (xyz(:,1) <= xm+params.Lx*kappa) ...
	 &    (xyz(:,2) >= ym-params.Ly*kappa) ...
	 &    (xyz(:,2) <= ym+params.Ly*kappa) );

% first decimate to maxNPix per tile, then drop minority cameras at seams.
% Otherwise you end up limited only by maxNPix and the weightings get funny
% for tiles with partial coverage.

del = max(1, length(idUse)/params.maxNPix);
idUse = idUse(round(1: del: length(idUse)));
subG = G(:,idUse);
subXYZ = xyz(idUse,:);
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
subXYZ = subXYZ(pick,:);


% problem: we've started getting subG's that came from missing data.
%  they are Inf because of the normalization in prepBathyInput, and they
%  mess up the EIG function in csmInvertKAlpha. Let's throw those columns
%  away. We may have no data (handled in subBathyProcess, or too little
%  data (handled in csmInvertKAlpha). 

% first, do we still have any data? 

if ~isempty(subG)
    
    [ugly, bad] = find(isnan(subG)); 
    all = 1:size(subG,2);
    good = setxor( all, unique(bad) );
    
    subG = subG(:,good);
    subXYZ = subXYZ(good,:);
    
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

