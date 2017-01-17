function bathy = analyzeSingleBathyRun(stackName)
%
%  bathy = analyzeSingleBathyRun(stackName)
%
%  simple run of analyzeBathyCollect for a single stackName.  Useful for
%  debugging.  Assumes CIL compatible stack.

DBConnect;
n = parseFilename(stackName);
eval(n.station)
bathy.epoch = n.time;
bathy.sName = stackName;
bathy.params = params;
[xyz, epoch, data] = loadBathyStack(bathy.sName, bathy.params.DECIMATE);
bathy = analyzeBathyCollect(xyz, epoch, data, bathy);

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: analyzeSingleBathyRun.m,v 1.1 2012/09/24 23:08:04 stanley Exp $
%
% $Log: analyzeSingleBathyRun.m,v $
% Revision 1.1  2012/09/24 23:08:04  stanley
% Initial revision
%
%
%key 
%comment  
%
