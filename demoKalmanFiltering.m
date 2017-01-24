% demo Kalman filter process using a one day set of cBathy results

clear
cBInputPn = '102210cBathys/';     % a simple example day, stored locally
fns = dir([cBInputPn,'*.mat']);
H = 1;            % assume wave height is 1 m if absence of better data

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

% compute the smoothed versions one at a time and store them in a different
% directory (only for demo).  Note that Kalman will start with second
% collect (averaging with first)
for i = 2: length(fns)
    load([cBInputPn, fns(i-1).name])
    priorBathy = bathy;
    load([cBInputPn, fns(i).name])
    bathy = KalmanFilterBathyNotCIL(priorBathy, bathy, H);
    eval(['save ' cBOutputPn,filesep, fns(i).name, ' bathy'])
end

% ONLY IF YOU WANT, DISPLAY RESULTS TO UNDERSTAND HOW THE KALMAN
% FILTER WORKS.  Usually you would NOT do this and it is only 
% included for demo purposes.  To avoid confusion it is now 
% commented out.  Uncomment to use.

%fns = dir([cBOutputPn,filesep,'*.mat']);

%for i = 1: length(fns)
%    load([cBOutputPn, filesep, fns(i).name])
%    plotBathyCollectKalman(bathy)
%    pause('Hit enter to continue to next collection')
%end
