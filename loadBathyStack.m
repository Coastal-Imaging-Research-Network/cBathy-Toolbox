function [xyz, epoch, data] = loadBathyStack(sName, decimate)
%
%   [xyz, epoch, data] = loadBathyStack(sName,decimate)
%
%  loads a bathy stack of name sName.  This routine is specific to
%  Argus protocols and should be replaced for other data sources like
%  UAVs.  The bathy stack is assumed to be of type matrix.  decimate 
%  obviously the decimation (2 means take every second point, etc)
%
% change 1: someone mixed two different 'matrix' instruments into the
%  stacks from Duck, so now I must pull out the mBW named ones myself

[stackNames, r] = loadAllStackInfo(sName);
if ~strmatch('matrix', unique([r.types]))
    error([sName ' contains no matrix instruments'])
end
ps = '';
[UV, names, xyz, cam, epoch, data, err] = ...
        loadFullInstFromStack(stackNames, r, 'matrix' );

%mine = strmatch( 'mBW', names, 'exact' );
mine = strmatch( 'mBW', names );
UV = UV(mine,:); names = names(mine); cam = cam(mine); data = data(:,mine);
xyz = xyz(mine,:);
%if (length(unique(names))>1)
%    error('Expecting only one matrix instrument mBW in stack')
%end

% load stackData      % avoid wasting time during development
foo = [1: decimate: size(data,2)]; % decimate for speed
data = data(:, foo);
xyz = xyz(foo,:);

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: loadBathyStack.m,v 1.2 2012/05/10 20:30:57 stanley Exp $
%
% $Log: loadBathyStack.m,v $
% Revision 1.2  2012/05/10 20:30:57  stanley
% removed specific mBW test from loadFullInstFromStack so all mBW* are
% loaded, then removed 'exact' from strmatch so that all mBW* are used.
% and removed "too many names" test, since Rob is now using mBW1, 2, etc.
%
% Revision 1.1  2011/08/08 00:28:52  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
