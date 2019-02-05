function h0 = findh0Duck(xm, ym, hMin)
%   h0 = findh0Duck(xm, ym, hMin)
%
%  Function to provide an initial guess at depth at a specified set of
%  analysis points, xm, ym, for a cBathy analysis.  The routine can be
%  approximate, but reasonable.  For shallow depths, it should threshold to
%  a minimum, hMin, which could be taken as 1 m.  
%  Ideally tide should be included, but we really only need an approximate
%  depth.

x0 = 100; x1 = 150;         % describe as roughly two linear segments
h1 = 2;
beta1 = 0.04;
beta2 = 0.008;

[X,Y] = meshgrid(xm,ym);
ind = find(X<=x1);
h0(ind) = (X(ind)-x0)*beta1;
ind = find(X>x1);
h0(ind) = h1 + (X(ind)-x1)*beta2;
h0 = reshape(h0, length(ym), length(xm));
h0(h0<hMin) = hMin;


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

