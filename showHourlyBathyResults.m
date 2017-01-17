function showHourlyBathyResults(startVec, endVec);
% showHourlyBathyResults([y1 m1 d1], [y2 m2 d2]);
%
% do plotBathyCollect for each available result within a range of days
% from year1, month1, day1 to year2, month2, day2

resultsPath = '/home/ruby/users/holman/research/BEACHWIZARD/BATHYRESULTS/argus02a/COLLECTIONRESULTS/';
epochStart = matlab2Epoch(datenum([startVec 0 0 0]));
epochEnd = matlab2Epoch(datenum([endVec 23 59 59]));

nms = dir([resultsPath '*mat']);
for i = 1: length(nms);
    foo = findstr('argus', nms(i).name);
    epoch = str2num(nms(i).name([1:foo-1]));
    if ((epoch>epochStart) & (epoch<epochEnd))
        load([resultsPath nms(i).name])
        plotBathyCollectSDS(bathy)
        pause
    end
end

    
%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: showHourlyBathyResults.m,v 1.1 2011/08/08 00:28:52 stanley Exp $
%
% $Log: showHourlyBathyResults.m,v $
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
