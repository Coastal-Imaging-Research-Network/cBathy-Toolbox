function showHourlyKalmanResults(stationStr, startVec, endVec);
% showHourlyKalmanResults(stationStr, [y1 m1 d1], [y2 m2 d2]);
%
% do plotBathyCollect for each available result within a range of days
% from year1, month1, day1 to year2, month2, day2.  Do not wrap years

resultsPath = ['/ftp/pub/' stationStr '/' num2str(startVec(1)) '/cx/']; 
startDay = argusDay(matlab2Epoch([startVec 0 0 0]));
endDay = argusDay(matlab2Epoch([endVec 0 0 0]));

for i = str2num(startDay(1:3)):str2num(endDay(1:3))
    foo = dir([resultsPath num2str(i) '*']);
    nms = dir([resultsPath foo.name '/*cBathy.mat']);
    for j = 2: length(nms);
        load([resultsPath foo.name '/' nms(j-1).name])
        priorBathy = bathy;
        load([resultsPath foo.name '/' nms(j).name])
        subplot(1,1,1);
        plotBathyKalmanStep(bathy, priorBathy)
        pause
        end
    end

    
%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: showHourlyKalmanResults.m,v 1.3 2013/01/14 18:56:36 stanley Exp $
%
% $Log: showHourlyKalmanResults.m,v $
% Revision 1.3  2013/01/14 18:56:36  stanley
% added a subplot to keep figure from shrinking with each plot
%
% Revision 1.2  2012/09/24 23:32:57  stanley
% name change of data
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
