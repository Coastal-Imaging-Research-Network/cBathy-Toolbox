function plotStacksAndPhaseMaps(xyz,t,data,f,G, params)
%   plotStacksAndPhaseMaps(xyz,t,data,f,G)
%
%  debugging tool for cBathy to show stacks and phase maps for the full
%  stack. Example stacks will show up in Figure 10 and phase maps in Figure
%  11, to preserve figures 1:nfB for analysis point debug plots
%% 
% find representative transects in x and y.
[xInd, yInd] = findGoodTransects(xyz, params);

%%

t = t(:,1);
tm = epoch2Matlab(t);

% begin plots
figure(10); set(gcf, 'name', 'Intensity Transects'); clf;  colormap(gray)
subplot 221
plot(xyz(:,1),xyz(:,2),'b.',xyz(xInd,1),xyz(xInd,2),'r+')
xlabel('x (m)'); ylabel('y (m)'); title('cross-shore transect')

subplot 222
plot(xyz(:,1),xyz(:,2),'b.',xyz(yInd,1),xyz(yInd,2),'r+')
xlabel('x (m)'); ylabel('y (m)'); title('longshore transect')

subplot 223
imagesc(xyz(xInd,1),tm,data(:,xInd))
datetick('y')
xlabel('x (m)'); ylabel('time (s)'); title('x-transect')

subplot 224
imagesc(xyz(yInd,2),tm,data(:,yInd))
datetick('y')
xlabel('y (m)'); ylabel('time (s)'); title('y-transect')

% now do phase maps.  Leave in natural order of freqs for simplicity
fB = params.fB;
nf = length(fB);
nCols = ceil(sqrt(nf));     % chose a reasonable number of rows and cols for display
nRows = ceil(nf/nCols);
figure(11); set(gcf, 'name', 'Phase Maps'); clf; colormap('jet');
for i = 1:nf
    ind = find(abs(f-fB(i)) == min(abs(f-fB(i))));
    subplot(nRows, nCols, i,'FontSize',7); hold on
    h=scatter(xyz(:,1),xyz(:,2),3,angle(G(ind,:)),'filled');
    xlabel('x (m)'); 
    ylabel('y (m)'); 
    axis equal;
    caxis([-pi pi]);
    axis ([ min(xyz(:,1)) max(xyz(:,1)) min(xyz(:,2)) max(xyz(:,2))]);
    view(2); 
    title(['f = ' num2str(fB(i),'%0.3g') ' Hz'],'FontWeight','normal','FontSize',9); 
    grid on
end

% figure(3); set(gcf,'name', 'Phase Transects'); clf;
% for i = 1: 3
%     subplot(3,2,2*i-1); hold on
%     plot(xyz(xInd,1),angle(G(sortInd(i),xInd)),'+-')
%     xlabel('x (m)'); ylabel('phase (rad)');
%     title(['freq = ' num2str(fs(i),'%0.3g') ' Hz']); grid on
%     subplot(3,2,2*i); hold on
%     plot(xyz(yInd,2),angle(G(sortInd(i),yInd)),'+-')
%     xlabel('y (m)'); ylabel('phase (rad)');
%     title(['freq = ' num2str(fs(i),'%0.3g') ' Hz']); grid on
% end

%
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

