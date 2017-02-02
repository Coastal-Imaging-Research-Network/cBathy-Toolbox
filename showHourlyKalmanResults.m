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

