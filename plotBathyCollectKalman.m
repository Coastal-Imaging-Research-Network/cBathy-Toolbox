function f = plotBathyCollectSDS(bathy)

%
%   plotBathyCollect(bathy)
%
%  plots a bathymetry result showing the bathymetry and error for any
%  particular collection, sName (and corresponding cams)

f = gcf;
set(f,'RendererMode','manual','Renderer','painters');
cmap = colormap( 'jet' );
colormap( flipud( cmap ) );

% colormap( getCustomColormap );

clf;
subplot(121);
pcolor(bathy.xm, bathy.ym, bathy.runningAverage.h);
shading flat
caxis([0 10]);
set(gca, 'ydir', 'nor');
axis equal;
axis tight;
xlabel('x (Relative m)');
ylabel('y (Relative m)');
titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
    'mmm dd yyyy, HH:MM' );
title( titstr );
h=colorbar('peer', gca);
set(h, 'ydir', 'rev');
set(get(h,'title'),'string', 'h (m)')

subplot(122);
pcolor(bathy.xm, bathy.ym, -bathy.runningAverage.hErr);
shading flat
caxis([-2 0]);
set(gca, 'ydir', 'nor');
axis equal;
axis tight;
xlabel('x (Relative m)');
ylabel('y (Relative m)');
h=colorbar('peer', gca);
set( h, 'ydir', 'rev' ); 
foo = get( h, 'yticklabel' );
foo = num2str( abs(str2num(foo)), '%.1f' );
set( h, 'yticklabel', foo );
set( get(h,'title'), 'string', 'hErr (m)' );

return

function cmap = getCustomColormap

%slightly modified jet colormap. Inverted, cut off the ends, & made green a little bigger.
cmap = [
	1.0000 0.0000 0.0000;
	1.0000 0.0909 0.0000;
	1.0000 0.1818 0.0000;
	1.0000 0.2727 0.0000;
	1.0000 0.3636 0.0000;
	1.0000 0.4545 0.0000;
	1.0000 0.5455 0.0000;
	1.0000 0.6364 0.0000;
	1.0000 0.7273 0.0000;
	1.0000 0.8182 0.0000;
	1.0000 0.9091 0.0000;
	1.0000 1.0000 0.0000;
	0.9615 1.0000 0.0385;
	0.9231 1.0000 0.0769;
	0.8846 1.0000 0.1154;
	0.8462 1.0000 0.1538;
	0.8077 1.0000 0.1923;
	0.7692 1.0000 0.2308;
	0.7308 1.0000 0.2692;
	0.6923 1.0000 0.3077;
	0.6538 1.0000 0.3462;
	0.6154 1.0000 0.3846;
	0.5769 1.0000 0.4231;
	0.5385 1.0000 0.4615;
	0.5000 1.0000 0.5000;
	0.4615 1.0000 0.5385;
	0.4231 1.0000 0.5769;
	0.3846 1.0000 0.6154;
	0.3462 1.0000 0.6538;
	0.3077 1.0000 0.6923;
	0.2692 1.0000 0.7308;
	0.2308 1.0000 0.7692;
	0.1923 1.0000 0.8077;
	0.1538 1.0000 0.8462;
	0.1154 1.0000 0.8846;
	0.0769 1.0000 0.9231;
	0.0385 1.0000 0.9615;
	0.0000 1.0000 1.0000;
	0.0000 0.9091 1.0000;
	0.0000 0.8182 1.0000;
	0.0000 0.7273 1.0000;
	0.0000 0.6364 1.0000;
	0.0000 0.5455 1.0000;
	0.0000 0.4545 1.0000;
	0.0000 0.3636 1.0000;
	0.0000 0.2727 1.0000;
	0.0000 0.1818 1.0000;
	0.0000 0.0909 1.0000;
	0.0000 0.0000 1.0000];


%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: plotBathyCollectKalman.m,v 1.1 2012/09/24 23:27:03 stanley Exp $
%
% $Log: plotBathyCollectKalman.m,v $
% Revision 1.1  2012/09/24 23:27:03  stanley
% Initial revision
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
