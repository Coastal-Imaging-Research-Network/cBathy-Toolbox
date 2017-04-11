% This script is designed to demonstrate the cBathy Toolbox in production
% mode and in debug mode. It also demonstrates some of the plotting
% functions to investigate cBathy results. It was developed as a
% demonstration for CIRN Boot Camp #1, 3/2017. It is designed to be stepped
% through line by line while reading the comments.

clear

% find the path to the cBathy Toolbox
cBathyToolboxPath = what('cbathy-Toolbox');

% cd to the cBathy Toolbox directory to run demo
cd(cBathyToolboxPath.path)

% look at the contents of the toolbox
help cbathy-Toolbox

%% set to production mode and process
% First open the "settings" file argus02a.m in the editor and look at inputs
edit argus02a

% run the cBathyDemo
democBathy

% look at cBathy result compared to survey plotted in figure 1

% look at the output variable names in the command window
whos 

% plot the different components for each frequency of cBathy output
figure
examineSingleBathyResult(bathy)

% plot the fCombined cBathy result (left panel) and the fCombined error
% (right panel) of figure 2
figure(2)
plotBathyCollect(bathy)

%% run again in debug mode
% set to debug mode by changing value of params.debug.production = 0
% in argus02a.m 
edit argus02a

% pre-open figures and set colormap to jet to view that phase maps more
% clearly
figure(10)
colormap jet

figure(11)
colormap jet

% run cBathy again in debug mode
democBathy

% In the debug mode, cBathy will ask at the command line if you want to 
% look at a subset of the cBathy domain. You only want to look at a few 
% pixels in the middle of the cBathy domain for debugging. Copy and paste
% these values for the range of pixels to look at: 
%[250 275 25 700 725 25]

% follow instructions in command window

% get rid of all of those plots
close all

% plot the cBathy matrix in time to look like a low resolution movie (you 
% should see waves)
figure
map = showcBathyTimeSeriesMovieNotCIL(stackName,[80 10 500 500 25 700]);

%% run the Kalman filter demo
% should step through Kalman filtered results with 2 second pause between
% results
figure(1)
demoKalmanFiltering

% open a prior and current bathy. 
pb = load([cBathyToolboxPath.path,'\102210cBathysSmoothed\1287759600.Fri.Oct.22_15_00_00.GMT.2010.argus02a.cx.cBathy.mat']);
priorBathy = pb.bathy;
load([cBathyToolboxPath.path,'\102210cBathysSmoothed\1287763200.Fri.Oct.22_16_00_00.GMT.2010.argus02a.cx.cBathy.mat'])

% compare the prior Kalman filtered bathymetry, the updated bathy, and the
% updated Kalman filtered bathymetry
plotBathyKalmanStep(bathy, priorBathy)

% In the plot, the upper left panel is the prior
% Kalman filtered bathymetry, the lower left panel is the prior Kalman
% filtered error, the upper middle plot is the updated bathymetry from cBathy
% phase 2, the lower middle panel is the updated error from phase 2, the
% right upper panel is the phase 3 Kalman filtered bathymetry, and the
% phase 3 error

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

