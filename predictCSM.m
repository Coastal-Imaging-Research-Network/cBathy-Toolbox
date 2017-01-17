function q = predictCSM(kAlphaPhi, xyw)
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
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: predictCSM.m,v 1.2 2012/09/24 23:30:21 stanley Exp $
%
% $Log: predictCSM.m,v $
% Revision 1.2  2012/09/24 23:30:21  stanley
% many changes
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%

