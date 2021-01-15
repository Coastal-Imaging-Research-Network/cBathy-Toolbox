function figNum = plotBathyCollect(bathy, figNum)

%
%   plotBathyCollect(bathy, {figNum})
%
%  plots a bathymetry result showing the bathymetry and error.  Allows
%  optional choice of figure number, otherwise defaults to the current
%  figure.

% set up the figure
if nargin<2
    figNum = figure;
else
    figure(figNum);
    clf;
end
set(figNum,'RendererMode','manual','Renderer','painters',...
    'Units','normalized',...
    'Position',[0.2,0.2,0.6,0.6],...
    'Colormap',flipud(jet));
set(figNum,'Units','pixels');
% cmap = colormap( 'jet' );
% colormap( flipud( cmap ) );

% plot the fCombined bathymetry

ax1=subplot(1,2,1);
set(ax1,'FontSize',14,'FontWeight','bold');
pcolor(ax1,bathy.xm, bathy.ym, bathy.fCombined.h);
shading flat
caxis([0 10]);
set(gca, 'ydir', 'nor');
axis equal;
axis tight;
xlabel('x (m)');
ylabel('y (m)');
titstr=datestr(datenum('19700101','yyyymmdd')+str2double(bathy.epoch)/24/3600,...
    'mmm dd yyyy, HH:MM');
% titstr = datestr( epoch2Matlab(str2num(bathy.epoch)), ...
%     'mmm dd yyyy, HH:MM' );
title( titstr ,'FontSize',14,'FontWeight','bold');
h=colorbar('peer', gca);
set(h, 'ydir', 'rev');
set(get(h,'title'),'string', 'h (m)')

ax2=subplot(1,2,2);
set(ax2,'FontSize',14,'FontWeight','bold');

pcolor(ax2,bathy.xm, bathy.ym, -bathy.fCombined.hErr);
shading flat
caxis([-2 0]);
set(gca, 'ydir', 'nor');
axis equal;
axis tight;
xlabel('x (m)');
ylabel('y (m)');
h=colorbar('peer', gca);
set( h, 'ydir', 'rev' ); 
tickLabels = get( h, 'yticklabel' );
tickLabels = cellstr(tickLabels);
for ll=1:length(tickLabels)
tickLabels{ll} = num2str( abs(str2double(tickLabels{ll})), '%.1f' );
end
drawnow
set( h, 'yticklabel', tickLabels );
set( get(h,'title'), 'string', 'hErr (m)' );

return


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
