function q = predictCSM( kAlphaPhi,xyw)
% q = predictCSM(kAlphaPhi, xyw)
%
% compute complex cross-spectral matrix from wavenumber and direction,
% kAlpha for x and y lags in first 2 cols of xyw.  Third column accounts
% for weightings.
% 
% Input
%   kalphaPhi = [k, alpha, phi], wavenumber (2*pi/L) and direction
%   (radians) and phi is a phase angle (with no later utility)
%   xyw, delta_x, delta_y, weight
%  
% Output
%   q, complex correlation q = exp(i*(kx*dx + ky*dy + phi))
%   q is returned as a list of complex values but is returned as a single
%   list of real, then imaginary coefficients.

kx = -kAlphaPhi(1).*cos(kAlphaPhi(2));
ky = -kAlphaPhi(1).*sin(kAlphaPhi(2));
phi = kAlphaPhi(3);
kxky = [kx,ky];
q=exp(sqrt(-1)*(xyw(:,1:2)*kxky' + repmat(phi,size(xyw,1),1))).*xyw(:,3);
q = [real(q); imag(q)];

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

