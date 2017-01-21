function f = plotBathyCollect(bathy, figNum)

%
%   plotBathyCollect(bathy, {figNum})
%
%  plots a bathymetry result showing the bathymetry and error.  Allows
%  optional choice of figure number, otherwise defaults to the current
%  figure.

% set up the figure
if nargin<2
    figNum = gcf;
end
set(figNum,'RendererMode','manual','Renderer','painters');
cmap = colormap( 'jet' );
colormap( flipud( cmap ) );

% plot the fCombined bathymetry
clf;
subplot(121);
pcolor(bathy.xm, bathy.ym, bathy.fCombined.h);
shading flat
caxis([0 10]);
set(gca, 'ydir', 'nor');
axis equal;
axis tight;
xlabel('x (m)');
ylabel('y (m)');
titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
    'mmm dd yyyy, HH:MM' );
title( titstr );
h=colorbar('peer', gca);
set(h, 'ydir', 'rev');
set(get(h,'title'),'string', 'h (m)')

subplot(122);
pcolor(bathy.xm, bathy.ym, -bathy.fCombined.hErr);
shading flat
caxis([-2 0]);
set(gca, 'ydir', 'nor');
axis equal;
axis tight;
xlabel('x (m)');
ylabel('y (m)');
h=colorbar('peer', gca);
set( h, 'ydir', 'rev' ); 
foo = get( h, 'yticklabel' );
for ll=1:length(foo)
foo{ll} = num2str( abs(str2num(foo{ll})), '%.1f' );
end
set( h, 'yticklabel', foo );
set( get(h,'title'), 'string', 'hErr (m)' );

return


%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: plotBathyCollectSDS.m,v 1.1 2011/08/08 00:28:52 stanley Exp $
%
% $Log: plotBathyCollectSDS.m,v $
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
