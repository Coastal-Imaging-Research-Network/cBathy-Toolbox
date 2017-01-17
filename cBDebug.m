function yesno = cBDebug( params, flag )

% function yesno = cBDebug( params, flag )
%
% tests the params struct for presence of 'flag'. 
%  flag is a string which will be looked for in the params.debug
%  struct. If it is there, return true.
%
%  if params.debug.production exists, always return false -- this
%   system is working in production mode and no debugging output
%    is allowed. If you want output from production mode, write it
%     in permanently.
%

if( isfield(params.debug, 'production') )
    if( params.debug.production ) 
        yesno = 0;
        return;
    end;
end

if nargin<2
	yesno = 1;
	return;
end

yesno = isfield( params.debug, flag ); 

if( yesno ) % field is present, return value
    yesno = getfield( params.debug, flag );
end

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: cBDebug.m,v 1.1 2012/09/24 23:13:34 stanley Exp $
%
% $Log: cBDebug.m,v $
% Revision 1.1  2012/09/24 23:13:34  stanley
% Initial revision
%
% Revision 1.1  2011/08/08 00:28:51  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
