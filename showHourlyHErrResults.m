function [epoch, hErrVar]=showHourlyHErrResults(startVec, endVec);
% showHourlyHErrResults([y1 m1 d1], [y2 m2 d2]);
%
% do plotBathyCollect for each available result within a range of days
% from year1, month1, day1 to year2, month2, day2

resultsPath = '/home/ruby/users/holman/research/BEACHWIZARD/BATHYRESULTS/argus02a/COLLECTIONRESULTS/';
epochStart = matlab2Epoch(datenum([startVec 0 0 0]));
epochEnd = matlab2Epoch(datenum([endVec 23 59 59]));

nms = dir([resultsPath '*mat']);
for i = 1: length(nms);
    foo = findstr('argus', nms(i).name);
    epoch(i) = str2num(nms(i).name([1:foo-1]));
end
good = find((epoch>=epochStart)&(epoch<=epochEnd));
nms = nms(good);
epoch = epoch(good);

for i = 2: length(nms);
        load([resultsPath nms(i-1).name])
        hErr2 = bathy.fCombined.hErr.^2;
        hErrVar(i) = nanmean(hErr2(:));
    end
end

figure(2); clf
plot(epoch2Matlab(epoch), hErrVar, '-+')
datetick('x', 1); xlabel('time'); ylabel('R (m^2)')
title(datestr(epoch2Matlab(epoch(1))))

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: showHourlyHErrResults.m,v 1.1 2011/08/08 00:28:52 stanley Exp $
%
% $Log: showHourlyHErrResults.m,v $
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
