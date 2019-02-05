function [fDep, camUsed] = subBathyProcess( f, G, xyz, cam, xm, ym, bathy )

%% subBathyProcess -- extract region from full bathy stack, process
%
%  fDep = subBathyProcess( f, G, xyz, cam, xm, ym, bathy )
%
%  f, G, xyz, cam are the full arryms. 
%  xm,ym is the desired analysis point.
%  bathy is the building result structure
%
%

%% first extract sub region.  Obsolete since tiles are now f-dependent size
% [subG, subXYZ, camUsed] = spatialLimitBathy( G, xyz, cam, xm, ym, ...
%                            bathy.params, bathy.kappa );
if( cBDebug( bathy.params, 'DOSHOWPROGRESS' ))
    figure(21);
    foo = findobj('tag','pixDots'); % tidy up old locations
    if ~isempty(foo)
        delete(foo)
    end
    foo = findobj('tag','xmDot');
    if ~isempty(foo)
        delete(foo)
    end
   % hp1 = plot(subXYZ(:,1), subXYZ(:,2), 'r.', 'tag', 'pixDots');
    hp2 = plot(xm, ym, 'g*', 'tag', 'xmDot');
end

%% now process!

[fDep, camUsed] = csmInvertKAlpha( f, G, xyz, cam, xm, ym, bathy );

%% how simple!

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

