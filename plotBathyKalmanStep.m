function plotBathyKalmanStep(bathy, priorBathy)

%
%   plotBathyKalmanStep(bathy, priorBathy)
%
%  plots a bathymetry result showing the bathymetry and error for any
%  particular collection, sName (and corresponding cams)

%f = figure(1); clf;
cmap = colormap( 'jet' ); colormap( flipud( cmap ) );
hLim = [-1 10]; eLim = [-1.0 0];

subplot(231); pcolor(bathy.xm, bathy.ym, priorBathy.runningAverage.h);
shading flat; caxis(hLim); set(gca, 'ydir', 'nor');
axis equal; axis tight;
xlabel('x (Relative m)'); ylabel('y (Relative m)');
title('Prior');
h=colorbar('peer', gca); set(h, 'ydir', 'rev'); set(get(h,'title'),'string', 'h (m)')

subplot(232); pcolor(bathy.xm, bathy.ym, bathy.fCombined.h);
shading flat; caxis(hLim); set(gca, 'ydir', 'nor');
axis equal; axis tight;
xlabel('x (Relative m)'); ylabel('y (Relative m)');
titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
    'mmm dd yyyy, HH:MM' );
title( titstr );
h=colorbar('peer', gca); set(h, 'ydir', 'rev'); set(get(h,'title'),'string', 'h (m)')

subplot(233); pcolor(bathy.xm, bathy.ym, bathy.runningAverage.h);
shading flat; caxis(hLim); set(gca, 'ydir', 'nor');
axis equal; axis tight;
xlabel('x (Relative m)'); ylabel('y (Relative m)');
title('Updated');
h=colorbar('peer', gca); set(h, 'ydir', 'rev'); set(get(h,'title'),'string', 'h (m)')

subplot(234);
pcolor(bathy.xm, bathy.ym, -priorBathy.runningAverage.hErr);
shading flat; caxis(eLim); set(gca, 'ydir', 'nor');
axis equal; axis tight;
xlabel('x (Relative m)'); ylabel('y (Relative m)'); 
title('Prior Err')
h=colorbar('peer', gca); set( h, 'ydir', 'rev' ); 
foo = get( h, 'yticklabel' );
foo = strrep(foo,'-','');
set( h, 'yticklabel', foo );
set( get(h,'title'), 'string', '(m)' );

subplot(235);
pcolor(bathy.xm, bathy.ym, -bathy.fCombined.hErr);
shading flat; caxis(eLim); set(gca, 'ydir', 'nor');
axis equal; axis tight;
xlabel('x (Relative m)'); ylabel('y (Relative m)');
title('Obs Err')
h=colorbar('peer', gca); set( h, 'ydir', 'rev' ); 
foo = get( h, 'yticklabel' );
foo = strrep(foo,'-','');
set( h, 'yticklabel', foo );
set( get(h,'title'), 'string', '(m)' );

subplot(236);
pcolor(bathy.xm, bathy.ym, bathy.runningAverage.K);
shading flat; caxis([0 1]); set(gca, 'ydir', 'nor');
axis equal; axis tight;
xlabel('x (Relative m)'); ylabel('y (Relative m)');
title('K')
h=colorbar('peer', gca);  
foo = get( h, 'yticklabel' );
foo = strrep(foo,'-','');
set( h, 'yticklabel', foo );

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

