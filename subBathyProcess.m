function fDep = subBathyProcess( f, G, xyz, xm, ym, params, kappa )

%% subBathyProcess -- extract region from full bathy stack, process
%
%  fDep = subBathyProcess( f, G, xyz, xm, ym, params, kappa )
%
%  f, G, xyz are the full arryms. 
%  xm,ym is the desired analysis point.
%  params is the parameter structure
%  kappa is the cross-shore variable sample domain scaling factor for this
%       position
%

%% first extract sub region

[subG, subXYZ] = spatialLimitBathy( G, xyz, xm, ym, params, kappa );
if( cBDebug( params, 'DOSHOWPROGRESS' ))
    figure(21);
    foo = findobj('tag','pixDots'); % tidy up old locations
    if ~isempty(foo)
        delete(foo)
    end
    foo = findobj('tag','xmDot');
    if ~isempty(foo)
        delete(foo)
    end
    hp1 = plot(subXYZ(:,1), subXYZ(:,2), 'r.', 'tag', 'pixDots');
    hp2 = plot(xm, ym, 'g.', 'tag', 'xmDot');
end


%% anything to process?

if isempty(subG)
	fDep.k = nan(params.nKeep,1);
	return;
end

%% now process!

fDep = csmInvertKAlpha( f, subG, subXYZ, xm, ym, params, kappa );

%% how simple!

 

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

