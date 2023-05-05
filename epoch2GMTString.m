function str = epoch2GMTString(time);

% usage: str = epoch2GMTString( time );
%
% returns a time string based on the Unix epochtime
% specified by 'time'. The input is a double.
% time is a double = seconds since 1970
% 
% NOTE: WaRNiNg: time is "epochtime", output is GMT. Always.
%

% 08/04/99: Extended by Stefan to operate on [m x 1] matrices
%
% 02/22/00: converted from Dutch to American
%           added "GMT" to the string to show timezone, also
%           to make it look more like a filename
%
% 03/07/00: changed from ctime.m to epoch2GMTString
% 04/22/03: changed to call epoch2LocalString with appropriate
%           parameters. Stupid to duplicate this code.
%

str = epoch2LocalString( time, 0, 'GMT' );
return;

% remainder is obsolete code that is mostly duplicate of
%epoch2LocalString.

% get days since 1970
time1970 = repmat(datenum('01-Jan-1970 00:00:00'),size(time)); 

% get string: 'dd-mmm-yyyy HH:MM:SS'
str1 = datestr(time/(24*3600)+time1970,0);

% need day of week: 'ddd'
str2 = datestr(time/(24*3600)+time1970, 8);

% put it together
str = [ str2, ...			% Tue
	repmat('.',size(time)), ...	% .
	str1(:,4:6), ...		% Aug
	repmat('.',size(time)), ...	% .
	str1(:,1:2), ...		% 18
	repmat('_',size(time)), ...	% _
	str1(:,13:20), ...		% 00:00:06
	repmat('.',size(time)), ...	% .
	repmat('GMT.',size(time)), ...	% GMT.
	str1(:,8:11)];			% 1998

% test it on this: 903398406.Tue.Aug.18_000006.GMT.1998.argus00.c0.timex.jpg

%
% Copyright by Oregon State University, 2002
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: epoch2GMTString.m,v 1.1 2004/08/18 20:27:16 stanley Exp $
%
% $Log: epoch2GMTString.m,v $
% Revision 1.1  2004/08/18 20:27:16  stanley
% Initial revision
%
%
%key time 
%comment  Converts epoch time into ascii GMT  
%
