% This is an example m-file to demonstrate how to run cBathy and display
% results.  It uses a supplied example data set and does not make
% assumptions about CIL conventions or databases.

clear
% Do a single cBathy analysis, returning the bathy structure (which you
% would normally save somewhere) and displaying the results.  
stationStr = 'argus02a';
stackName = 'testStack102210Duck';
bathy = analyzeSingleBathyRunNotCIL(stackName, stationStr);
bathy.params.debug.production=1;
plotBathyCollect(bathy)

% Now compare this result with a supplied example CRAB survey from three
% days prior.
CRABpn = '19-Oct-2010FRFGridded.mat';
load(CRABpn)
figure(1); clf
subplot(121)
imagesc(xm,ym,zi); grid on; caxis([-8 1])
axis xy; xlabel('x (m)'); ylabel('y (m)'); title(['CRAB, ' CRABpn])

% remove results with HErr greater than a threshold and plot cBathy results
subplot(122)
h2 = bathy.fCombined.h;
threshErr = 1.0;
h2(bathy.fCombined.hErr>threshErr) = nan;
imagesc(bathy.xm,bathy.ym,-h2); grid on
caxis([-8 1])
axis xy; xlabel('x (m)'); ylabel('y (m)'); 
title(['cBathy, ' datestr(epoch2Matlab(str2num(bathy.epoch)))])

% Finally, try turning on the debug feature and test it using guidance from
% the user manual.  This is done by setting params.debug.production to 0.
% You may want to change some of the debug options.  You then simply repeat
% the analyzeSingleBathyNotCIL commands.

