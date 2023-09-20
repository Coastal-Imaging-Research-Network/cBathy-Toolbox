% test the new version 3.0 of cBathy for short records 
%  Use the new test bed data set from 2015 on.
%  Note that I am running this from within cBathy/seedTesting2019 since this
%  will have the new version routines in the path.

clear
testBedfn = '/ftp/pub3/Experiments/DuckcBathyTests/bathyTestDataSet.mat';
load(testBedfn)
savepn = 'testBedOutput0719/';
n.station = 'argus02b';

i = 1;      % example test data set

for i = 1: 1 %length(bathyTestDataSet)
    savepnLong = [savepn bathyTestDataSet(i).surveyDateStr([1 2 4 5 7 8]) '/'];
    mkdir(savepnLong)
    % do every hour (skip every second one
    for j = 1: 2: length(bathyTestDataSet(i).ArguscBathyFiles)
        
        clear
        sn = FTPPath('1443632340.Wed.Sep.30_16_59_00.GMT.2015.argus02b.cx.mBW.mat');
        %sn = bathyTestDataSet(i).ArguscBathyFiles(j,:);
        n.time = sn(38:47);
        n.station = 'argus02b';
        mBWPathname = sn;
        bathy = analyzeSingleBathyRunFrommBW(sn,n);
        
        
        
        
        toc
        bathy.cpuTime = toc;
        eval(['save ' savepnLong sn(38:47) 'cBathy' n.station ' bathy'])
        plotBathyCollect(bathy)
        drawnow
    end
end


