function bathyErr = bathyCI(resid,J,w)
% 
%   bathyErr = bathyCI(resid,J,w)
%
%  altered version of nlparci specifically modified to handle the bathy
%  estimation problem for cBathy and to account for the weighted
%  contribution to the sum of squares.  The only change is to reduce the
%  number of degrees of freedom depending on the weights, w.
%
%  Inputs:
%   resid   - Nx1 vector or prediction residuals from k-estimates
%   J       - Jacobian (both these are from nlinfit)
%   w       - weights used in weighted nlinfit
%  Output:
%   bathyErr - 95% confidence interval on depth estimate.
%
%  Scalped from nlparci for special case of single parameter (bathy)
%  estimation.  Holman, 2012.

alpha = 0.05;

n = sum(w)/max(w);  % Holman kludge
v = n-1;

% Calculate covariance matrix
[~,R] = qr(J,0);
Rinv = R\eye(size(R));
diag_info = sum(Rinv.*Rinv,2);

rmse = norm(resid) / sqrt(v);
se = sqrt(diag_info) * rmse;

% Calculate bathyError from t-stats.
bathyErr = se * tinv(1-alpha/2,v);


%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: bathyCI.m,v 1.1 2012/09/24 23:09:19 stanley Exp $
%
% $Log: bathyCI.m,v $
% Revision 1.1  2012/09/24 23:09:19  stanley
% Initial revision
%
%
%key 
%comment  
%
