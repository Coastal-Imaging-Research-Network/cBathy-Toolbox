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
foo = num2str( abs(str2num(foo)), '%.1f' );
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
foo = num2str( abs(str2num(foo)), '%.1f' );
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
foo = num2str( abs(str2num(foo)), '%.1f' );
set( h, 'yticklabel', foo );

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: plotBathyKalmanStep.m,v 1.2 2012/09/24 23:28:22 stanley Exp $
%
% $Log: plotBathyKalmanStep.m,v $
% Revision 1.2  2012/09/24 23:28:22  stanley
% plot limits
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
