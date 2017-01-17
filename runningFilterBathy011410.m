function runningFilterBathy(startVec, endVec)
%
%  runningFilterBathy([y1 m1 d1], [y2 m2 d2])
%
% wrapper filter routine to smooth consecutive bathy collects and save
% them.  Goes to the bathyCollectPath and finds all collection results
% between time1 (y1 m1 d1) and time2.  It then computes a Kalman filter
% smoothing of each in turn.  If the first bathy doesn't have a Kalman
% seed, it creates the seed.  Results can be examined with
% plotBathyKalmanStep to check performance.
% Results are simply saved locally for now in resultsPath.


resultsPath = '/home/ruby/users/holman/research/BEACHWIZARD/BATHYRESULTS/argus02a/COLLECTIONRESULTS/';
nms = dir([resultsPath '*mat']);
load(FTPPath(nms(1).name)); % seed
bathy = makeKalmanBathySeed(bathy);
eval(['save ' resultsPath nms(1).name ' bathy'])

DBConnect

for i = 2: length(nms)
    waves = DuckGetWaves(str2num(nms(i).name(1:10)), 3111);
    load([resultsPath nms(i-1).name]);
    prior = bathy;
    load(FTPPath(nms(i).name))
    bathy = KalmanFilterBathy(prior, bathy, waves.hmo);
    eval(['save ' resultsPath nms(i).name ' bathy'])
end


%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: runningFilterBathy011410.m,v 1.1 2011/08/08 00:28:52 stanley Exp $
%
% $Log: runningFilterBathy011410.m,v $
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
