%cBathyDemo2023Short.m


clear

% look at the contents of the toolbox using the local toolbox name.  
% You may want to simplify this name to something like "cBathy".
help cbathy-Toolbox-master-2;       % this is the CIRN default name

%% set to production mode and process
% First open the "settings" file argus02b.m in the editor and look at inputs
% Ensure that production mode = 1 and reduce xyMinMax to [80 500 0 1000]
edit argus02b

% Let's pick a low energy example run stored in DemoData
% snapPn = 'DemoData/1447691400.Mon.Nov.16_16_30_00.GMT.2015.argus02b.c2.snap.jpg';
% dataStackName = 'DemoData/1447691340.Mon.Nov.16_16_29_00.GMT.2015.argus02b.cx.mBW.mat';

% Here is a more energetic run two days later.  Un-comment and use this as 
% a second example later, running the same analysis fo these different
% conditions
snapPn = 'DemoData/1447864200.Wed.Nov.18_16_30_00.GMT.2015.argus02b.c2.snap.jpg';
dataStackName = 'DemoData/1447862340.Wed.Nov.18_15_59_00.GMT.2015.argus02b.cx.mBW.mat';

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
bathy = analyzeBathyCollectShort(XYZ, T(1:180), RAW(1:180,:), CAM, bathy)

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
