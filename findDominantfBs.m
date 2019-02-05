function fs = findDominantfBs(f, G, xyz, cam, xm, ym, bathy)
%   fs = findDominantfBs(f, G, xyz, cam, xm, ym, bathy);
%
%  Compute the cross-spectral matrix for any xm, ym location based on the
%  standard tile size (+/- Lx and Ly) based on the highest nKeep bands in
%  total coherence.

% spatially limit to local standard tile
[G] = spatialLimitBathy(G, xyz, cam, xm, ym, ...
                bathy.params.Lx, bathy.params.Ly, bathy.params.maxNPix );
for i = 1: length(bathy.params.fB)
    id = find(abs(bathy.params.fB(i)-f) < (bathy.params.fB(2)-bathy.params.fB(1))/2);     % find the f's that match
    C(:,:,i) = G(id,:)'*G(id,:) / length(id);   % pos 2nd leads 1st.
end

% create the coherence squared for all the potential frequence bands
coh2 = squeeze(sum(sum(abs(C))));
[~, coh2Sortid] = sort(coh2, 1, 'descend');  % sort by coh2
fs = bathy.params.fB(coh2Sortid(1:bathy.params.nKeep));         % keep only the nKeep most coherent

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

