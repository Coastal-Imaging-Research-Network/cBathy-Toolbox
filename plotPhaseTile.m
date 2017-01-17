function plotPhaseTile(xy, v, vPred)
%
%  plotPhaseTile(xy, v, vPred)
%
%  plots the phase and amplitude of eigenvector modes (or data) in xy space
%  using the complex eigenvector (or csm) v.  Uses scatter 3 since it does
%  not assume regular spacing.  v is assumed to be a  vector of complex
%  coefficients (solution is done as concatenated real then imaginary
%  coeffs, so you need to to assemble the complex valued list).  vPred is
%  the predicted eigenvector structure, for comparison

va = angle(v)*180/pi;
vpa = angle(vPred)*180/pi;
subplot(221)
scatter3(xy(:,1), xy(:,2), va, [], va);
view(2); caxis([-180 180]);  colorbar
xlabel('x (m)'); ylabel('y (m)'); title('Observed phase')

subplot(222)
scatter3(xy(:,1), xy(:,2), abs(v), [], abs(v));
view(2); colorbar
xlabel('x (m)'); ylabel('y (m)'); title('Observed magnitude')

subplot(223)
scatter3(xy(:,1), xy(:,2), vpa, [], vpa);
view(2); caxis([-180 180]); colorbar
xlabel('x (m)'); ylabel('y (m)'); title('Predicted phase')

subplot(224)
scatter3(xy(:,1), xy(:,2), abs(vPred), [], abs(vPred));
view(2); colorbar
xlabel('x (m)'); ylabel('y (m)'); title('Predicted magnitude')

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: plotPhaseTile.m,v 1.1 2012/09/24 23:29:35 stanley Exp $
%
% $Log: plotPhaseTile.m,v $
% Revision 1.1  2012/09/24 23:29:35  stanley
% Initial revision
%
%
%key 
%comment  
%
