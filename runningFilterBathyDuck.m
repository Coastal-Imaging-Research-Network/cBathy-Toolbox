%function runningFilterBathyDuck
%
%  runningFilterBathyDuck
%
% Read bathy files in a series of local directories and compute
% Kalman-filtered results.  For comparison with CRAB surveys from 2009 to
% 2011 for cBathy paper.

clear all
resultsPath = '/home/ruby/users/holman/research/BEACHWIZARD/BATHYRESULTS/argus02a/';
nms = dir([resultsPath '20*']);
DBConnect
hWait = waitbar(0);

for test = 1: length(nms)
    waitbar(test/length(nms),hWait)
    testStr = [nms(test).name '/'];
    files = dir([resultsPath testStr '*mat']);
    load([resultsPath testStr files(1).name])
    bathy = makeKalmanBathySeed(bathy);
    eval(['save ' resultsPath testStr files(1).name ' bathy'])
    for i = 2: length(files)
        load([resultsPath testStr files(i-1).name])
        prior = bathy;
        load([resultsPath testStr files(i).name])
        waves = DuckGetWaves(str2num(bathy.epoch), 630);
        if isempty(waves)
            waves(1).hmo = 1.0;    % default wave height
            warning(['No wave data for ' bathy.sName])
        end
        bathy = KalmanFilterBathy(prior, bathy, waves.hmo);
        eval(['save ' resultsPath testStr files(i).name ' bathy'])
    end
end

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: runningFilterBathyDuck.m,v 1.1 2012/09/24 23:31:54 stanley Exp $
%
% $Log: runningFilterBathyDuck.m,v $
% Revision 1.1  2012/09/24 23:31:54  stanley
% Initial revision
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
