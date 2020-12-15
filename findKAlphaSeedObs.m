function [kAlpha0, centerInd] = findKAlphaSeed(xy, v, xm, ym)
%   [kAlpha0, centerInd] = findKAlphaSeed(xy, v, xm, ym)
% Given a phase tile v at locations xy, find good seed estimates for the
% wave angle and wavenumber that will be used for the nonlinear search in
% csmInvertKAlpha.  This version uses the radon transform to find the
% dominant wave direction.
% Outputs are the two parameters, k and alpha, plus the center index
% of the pixel that is closest to xm, ym.  This will be used to correct
% phase in predictCSM.
% Erwin Bergsma (erwin.bergsma@legos.obs-mip.fr)
% July 2019
%

%% Phase ramp over tile:
va = angle(v);

%% Interpolation (Radon only works on equidistantly space data)
% note, dx and dy can be modified
dxy = 4;	% changed from 2 to speed things up
x1 = min(xy(:,1)); x2 = max(xy(:,1)); y1 = min(xy(:,2)); y2 = max(xy(:,2));
x = x1: dxy: x2;
y = y1: dxy: y2;
[X, Y] = meshgrid(x,y);
Iz = griddata(xy(:,1), xy(:,2), va, X, Y);
bad = isnan(Iz);
Iz(bad) = mean(~bad(:)); % Radon does not allow for NaNs --> filled with mean

%% Apply radon over theta
theta = -pi/4: pi/100: pi/4;
R = radon(Iz,theta*180/pi);

%% Pick the direction with maximum variance (representing the incident wave angle) 
[~,c] = max(var(R));
aSeed = -theta(c); % result in radians.

%% Estimate the wave number projected in the incident wave direction.  Establish
%  a grid oriented in the wave direction that spans the original tile, then
%  interp into the original phase map to re-map to wave-directed coords.
%  Then chose the median gradient as the seed wavenumber.
corners = [x1 y1; x1 y2; x2 y1; x2 y2];
xProj = corners(:,1)*cos(aSeed) + corners(:,2)*sin(aSeed);
yProj = -corners(:,1)*sin(aSeed) + corners(:,2)*cos(aSeed);
[XProj, YProj] = meshgrid(min(xProj): dxy: max(xProj), min(yProj): dxy: max(yProj));
XUnProj = XProj(:)*cos(aSeed) - YProj(:)*sin(aSeed);
YUnProj = XProj(:)*sin(aSeed) + YProj(:)*cos(aSeed);
IRot = interp2(x,y,Iz,XUnProj(:), YUnProj(:));
IRot = reshape(IRot, size(XProj));
dPhidx = diff(IRot')/dxy;
kSeed = -median(dPhidx(:),'omitnan');

% finally find the point closest to xm,ym for later phase setting in
% predictCSM.
d = sqrt((xy(:,1) - xm).^2 + (xy(:,2)-ym).^2);
[~,centerInd] = min(d);

kAlpha0 = [kSeed aSeed];
