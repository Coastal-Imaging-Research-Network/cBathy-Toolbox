% This script is designed to demonstrate the cBathy Toolbox in production
% mode and in debug mode. It also demonstrates some of the plotting
% functions to investigate cBathy results. It was originally developed as a
% demonstration for CIRN Boot Camp #1, 3/2017 and has been updated for 2023.
% It is designed to be stepped through line by line while reading the comments.
% This routine is intended to be run from the cBathy toolbox.  Normally you
% would run cBathy from a separate directory and would write-protect the
% cBathy directory
% This routine uses data from a folder "DemoData" that is part of the toolbox. 
% This contains data from two contrasting runs from 2015.  In addition, the
% Kalman filtering demo toward the end expects to be able to write its
% output to a directory in the local directory.  If you don't have write
% permission, you will need to specify an alternate location around line 12 of
% demoKalmanFiltering (variable cBOutputPn) where you do have write
% permission.
%
% During the boot camp, we will go through this routine step by step as a
% way to explain all the features of cBathy.  If not at the boot camp, we
% recommend that you also go line by line to best understand.  The routine
% can also be used simply as examples of code that you might use later.

%  Rob Holman, April, 2023.

clear

% look at the contents of the toolbox using the local name.  You may want
% to simplify this name to something like "cBathy".
help cbathy-Toolbox-master-2

%% set to production mode and process
% First open the "settings" file argus02a.m in the editor and look at inputs
% Ensure that production mode = 1 and reduce xyMinMax to [80 500 0 1000]
edit argus02b

% Let's pick a low energy example run stored in DemoData
snapPn = 'DemoData/1447691400.Mon.Nov.16_16_30_00.GMT.2015.argus02b.c2.snap.jpg';
dataStackName = 'DemoData/1447691340.Mon.Nov.16_16_29_00.GMT.2015.argus02b.cx.mBW.mat';

% Here is a more energetic run two days later.  Use this as a second
% example later.
%  snapPn = 'DemoData/1447864200.Wed.Nov.18_16_30_00.GMT.2015.argus02b.c2.snap.jpg';
%  dataStackName = 'DemoData/1447862340.Wed.Nov.18_15_59_00.GMT.2015.argus02b.cx.mBW.mat';

% show the snapshot from this time to get a feel for the waves
ISnap = imread(snapPn);
figure(3); clf; imagesc(ISnap); axis off; title(snapPn)

% Now load the stack then look at the variables.  Note the number of
% pixels and the number of samples in time.  There is XYZ data for each
% pixel.  We use RAW as the variable name for the data.  
load(dataStackName) 
whos

% now load the params file and look at the params variable
stationStr = 'argus02b';
eval(stationStr)        % creates the params structure.

% Create a few basic parts of the output bathy structure.
bathy.epoch = num2str(T(1));
bathy.sName = dataStackName;
bathy.params = params;

% now carry out the cBathy analysis.  Omit the semicolon at the end so we
% can see the full structure of the output.
bathy = analyzeBathyCollect(XYZ, T, RAW, CAM, bathy)

%% plot the fCombined cBathy result (left panel) and the fCombined error
% (right panel) of figure 1
figure(1)
plotBathyCollect(bathy)

% load the ground truth data for this run and trim to max x = 500;
% Note that this is one of many ground truth data sets that are part of
% BathyTestDataset.mat that anyone can use for testing.
load DemoData/bathyTestDataSubSet_Nov16_2015.mat
b = bathyTestDataSubSet.survey.gridded;        % easier to type
xInds = find(b.xm <= 500);

% first plot the cBathy result, removing results for which hErr > 0.5 m
figure(2); clf; colormap(flipud(jet))
subplot(121); 
bad = find(bathy.fCombined.hErr > 0.5);    % don't plot data with high hErr
h = bathy.fCombined.h; h(bad) = nan;
imagesc(bathy.xm, bathy.ym, h)
axis xy; axis tight; xlabel('x (m)'); ylabel('y (m)'); caxis([0 8])
title(['cBathy, ' datestr(epoch2Matlab(str2num(bathy.epoch)))]); colorbar; axis equal;

% now plot the survey data.  You need to plot -zi to correspond to positive
% depths
subplot(122); 
imagesc(b.xm(xInds), b.ym, -b.zi(:,xInds))
axis xy; axis tight; xlabel('x (m)'); ylabel('y (m)'); ; caxis([0 8]); colorbar
title(['survey, ' datestr(epoch2Matlab(str2num(bathy.epoch)))]); colorbar; axis equal;

%% plot the different components for each frequency of cBathy output as a 
% way to understand better the bathy structure.
colormap(jet);
examineSingleBathyResult(bathy)


% And now the brightest image
imagesc(bathy.xm, bathy.ym, bathy.bright); colormap(gray)    % time exposure
axis equal; xlabel('x (m)'); ylabel('y (m)'); title('cBathy Brightest')
axis tight


%% run again in debug mode.  Assume that your results don't seem to be working 
% First, look at the stack as a movie to see if waves are present
map = showcBathyTimeSeriesMovie(XYZ, T, RAW,[80 5 500 0 10 1000]);

% set to debug mode by changing value of params.debug.production = 0
% in argus02b.m 
edit argus02b

argus02b            % update params to be in debug mode.
bathy.params = params;

% run cBathy again in debug mode
bathy = analyzeBathyCollect(XYZ, T, RAW, CAM, bathy);

% In the debug mode, cBathy will ask at the command line if you want to 
% look at a subset of the cBathy domain. You only want to look at a few 
% pixels in the middle of the cBathy domain for debugging. Copy and paste
% these values for the range of pixels to look at: 
%     [250 275 25 700 725 25]

% follow instructions in command window

% get rid of all of those plots
close all



%% run the Kalman filter demo
% should step through Kalman filtered results with 2 second pause between
% results
figure(1)
demoKalmanFiltering

% open a prior and current bathy. 
pb = load('.\102210cBathysSmoothed\1287759600.Fri.Oct.22_15_00_00.GMT.2010.argus02a.cx.cBathy.mat');
priorBathy = pb.bathy;
load('.\102210cBathysSmoothed\1287763200.Fri.Oct.22_16_00_00.GMT.2010.argus02a.cx.cBathy.mat')

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

