nms = dir('BATHYRESULTS/argus02a/COLLECTIONRESULTS/*mat');

for i = 1: length(nms)
    eval(['load(''BATHYRESULTS/argus02a/COLLECTIONRESULTS/' nms(i).name ''');'])
    plotBathyCollectFiltered(bathy);
    figure(1); imagesc(bathy.runningAverage.K); caxis([0 1]); colorbar
    input('hit return to continue')
end

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: examineRunningAverageBathys.m,v 1.1 2011/08/08 00:28:51 stanley Exp $
%
% $Log: examineRunningAverageBathys.m,v $
% Revision 1.1  2011/08/08 00:28:51  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
