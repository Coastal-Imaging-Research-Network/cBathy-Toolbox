% This script is designed to demonstrate the cBathy Toolbox in production
% mode and in debug mode. It also demonstrates some of the plotting
% functions to investigate cBathy results. It was originally developed as a
% demonstration for CIRN Boot Camp #1, 3/2017 and has been updated for 2023.
% It is designed to be stepped through line by line while reading the comments.
% This routine is intended to be run from the cBathy toolbox.  Normally you
% would run cBathy from a separate directory and would write-protect the
% cBathy directory.  But this simplifies paths.
% This routine uses data from a folder "DemoData" that is part of the toolbox. 
% This contains data from two contrasting runs from 2015.  In addition, the
% Kalman filtering demo toward the end expects to be able to write its
% output to a directory in the local directory.  If you don't have write
% permission, you will need to specify an alternate location around line 12 of
% demoKalmanFiltering (variable cBOutputPn) where you do have write
% permission.
%
% During the boot camp, we will go through this routine step by step (cut 
% and paste) as a way to explain all the features of cBathy.  If not at 
% the boot camp, we recommend that you also go line by line to best 
% understand.  The routine can also be used simply as examples of code that 
% you might use later.

%  Rob Holman, April, 2023.

clear

% look at the contents of the toolbox using the local toolbox name.  
% You may want to simplify this name to something like "cBathy".
help cbathy-Toolbox-master-2;       % this is the CIRN default name

%% set to production mode and process
% First open the "settings" file argus02b.m in the editor and look at inputs
% Ensure that production mode = 1 and reduce xyMinMax to [80 500 0 1000]
edit argus02b

% Let's pick a low energy example run stored in DemoData
snapPn = 'DemoData/1447691400.Mon.Nov.16_16_30_00.GMT.2015.argus02b.c2.snap.jpg';
dataStackName = 'DemoData/1447691340.Mon.Nov.16_16_29_00.GMT.2015.argus02b.cx.mBW.mat';

% Here is a more energetic run two days later.  Un-comment and use this as 
% a second example later, running the same analysis fo these different
% conditions
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
clear bathy

%% The following are what you need to do to run cBathy
% Create a few basic parts of the output bathy structure.
bathy.epoch = num2str(T(1));        % epoch time start of collect
bathy.sName = dataStackName;        % stack name for the record
bathy.params = params;              % save the params data

% now carry out the cBathy analysis.  Omit the semicolon at the end so we
% can see the full structure of the output.  NOTE - this may take a minute.
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

% first plot the cBathy result, removing results for which hErr > 0.5 m (or
% you can choose a different threshold.  Note that for the first data run
% this only removes a few shoreline points.
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
axis xy; axis tight; xlabel('x (m)'); ylabel('y (m)'); caxis([0 8]); colorbar
title(['survey, ' datestr(epoch2Matlab(str2num(bathy.epoch)))]); colorbar; axis equal;

% Now look at the bathy.tide structure and notice that the default tide 
%  function failed (nan value).  EDIT argus02b again to change the tide
%  function to findTideForCIRNDemo2023 (save).  Then re-run the analysis from line 57,
%  but at line 85 use a different figure number (say 4) so you can compare the
%  results with and without correct tide.

%% Now plot the different components for each frequency of cBathy output as a 
% way to understand better the bathy structure.  Hit CR to cycle through
% each of the frequencies and look at things like the frequency order plot
% (bottom right, k and alpha plots (top left and middle) and their errors
% (second row)
figure(2); clf; colormap(jet);
examineSingleBathyResult(bathy)


% And now the proxy images.  There are timex, brightest and darkest images
% in the structure.  Just look at the timex now.
figure(2); clf;
imagesc(bathy.xm, bathy.ym, bathy.timex); colormap(gray)    % time exposure
axis equal; xlabel('x (m)'); ylabel('y (m)'); title('cBathy timex')
axis tight; axis xy



%% run again in debug mode.  Assume that your results don't seem to be working
% First, look at the stack as a movie to see if waves are present
map = showcBathyTimeSeriesMovie(XYZ, T, RAW,[80 5 500 0 10 1000]);

% set to debug mode by changing value of params.debug.production = 0
% in argus02b.m, then save and load the update.
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

% first look at windows 10 and 11.  The upper panels of 10 show the
% cross-shore and longshore transects selected for viewing.  These
% correspond to values in the settings file TRANSECTX and TRANSECTY.
% Choose appropriate values for your data set.  The lower panels of figure
% 10 show time stacks along those transects.  Zoom in to the x-transect to
% see if you can identify waves progressing toward the shore.  
%
% Look at figure 11 to see phase maps for different frequency slices.  They
% should show wave patterns which get shorter at higher frequencies.  
%
% If you don't see these basic wave characteristics, you have bad input
% data and cBathy will be unlikely to work.

% Now follow instructions in command window.  Hit CR to step through the
% four dominant frequencies for each requested tile.  It is best to arrange
% figures 1 through 4 in a 2 by 2 pattern so simplify viewing.  Look for
% model phase maps to look like data phase maps.  Figure 21 shows the tile
% location.

% get rid of all of those plots
close all

%% Now we return to the powerpoint to discuss Kalman filtering.



%% Run the Kalman filter demo
% This demo shows how the Kalman filter works, using a one-day set of
% twelve cBathy results, taken at hourly intervals on October 22, 2010.

clear
cBInputPn = '102210cBathys/';     % a simple example day, stored locally
fns = dir([cBInputPn,'*.mat']);
H = 1;            % assume wave height is 1 m in absence of better data

% Note that we will store the output in a different location for demo
% purposes.  You would normally save the result back where you found the
% original cBathy files.

cBOutputPn = '102210cBathysSmoothed';
if ~exist(cBOutputPn, 'dir')
    yesNo = mkdir(cBOutputPn);
    if ~yesNo
        error('Unable to create output directory')
    end
end

% For the first step, you combine observation 1 (1200 GMT) as a prior with
% observation 2 (1300 GMT) as the update.   Then observation 3 is combined
% with that Kalman result, etc.  These are all computed quickly saved in a
% separate directory so you can see fresh data in the demo.  
% You would normally keep the results in the original directory.

load([cBInputPn, fns(1).name])  % load initial estimate
for i = 2: length(fns)
    priorBathy = bathy;
    load([cBInputPn, fns(i).name])
    bathy = KalmanFilterBathy(priorBathy, bathy, H);
    eval(['save ' cBOutputPn,filesep, fns(i).name, ' bathy'])
end

% You can  step through Kalman filtered results one at a time.  Figure 1
% shows the slowly changing evolution of the Kalman filter, with the
% runningAverage h on the left side and hErr on the right.  Figure 2 shows
% how each step is computed.  The upper row shows the prior h (left) and 
% update h (middle) while the right panel shows the updated Kalman result
% that combines the two.  The lower panel shows the errors for the prior
% and update while the right panel shows the Kalman gain, K.
% estimates

fns = dir([cBOutputPn,filesep,'*.mat']);
for i = 2: length(fns)
   load([cBOutputPn, filesep, fns(i-1).name])
   priorBathy = bathy;
   load([cBOutputPn, filesep, fns(i).name])
   figure(1); plotBathyCollectKalman(bathy);
   figure(2); plotBathyKalmanStep(bathy,priorBathy);
   foo = input('Hit CR to continue - ');
end

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

