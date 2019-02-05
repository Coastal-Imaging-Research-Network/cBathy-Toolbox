function phi0 = findAlpha0(xy, v)
%   phi0 = findAlpha0(xy, v)
%
% Given a phase map in xy represented by the phases of complex
% eigenfunction v, find a decent estimate of the wave angle to be used as
% the seed for the nonlinear cBathy search.

a = angle(v);
x = [min(xy(:,1)): max(xy(:,1))];
y = [min(xy(:,2)): max(xy(:,2))];
[X,Y] = meshgrid(x,y);

% interpolate phase maps to regular grid
F = scatteredInterpolant(xy,a);
ai = F([X(:) Y(:)]);
ai = reshape(ai, length(y), length(x));
[gx, gy] = gradient(ai);
phi0 = atan(median(gy(:))/median(gx(:)));

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

