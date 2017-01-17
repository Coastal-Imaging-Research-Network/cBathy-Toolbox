function bathy = analyzeSingleBathyRunNotCIL(stackPnStr, stationStr)
%
%  bathy = analyzeSingleBathyRunNotCIL(stackPnStr, stationStr)
%
%  simple run of analyzeBathyCollect for a single stack.  Useful for
%  debugging.  Assumes stackPnStr is a loadable file which contains
%  variables 
%       epoch   - epoch times for each row in stack, Nt by 1
%       xyz     - xyz locations for each column in stack, Nxyz by 1
%       data    - Nt by Nxyz matrix of cBathy stack data
%
%   stationStr is the name of the station, for example 'argus02b' or
%   whatever naming convention you chose.  This name MUST correspond to a
%   callable m-file that creates the params structure that contains all of
%   the processing inputs.

eval(stationStr)        % creates the params structure.
load(stackPnStr)           % load xyz, t, data
bathy.epoch = num2str(t(1));
bathy.sName = stackPnStr;
bathy.params = params;
bathy = analyzeBathyCollect(xyz, t, data, bathy);

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
