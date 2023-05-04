function str = epoch2LocalString(time, offset, tzname);

% usage: str = epoch2LocalString( time,offset,tzname );
%
% returns a time string based on the Unix epochtime
% specified by 'time'. The input is a double.
% time is a double = seconds since 1970
%
%  offset is the offset from GMT to local time in minutes (-480 for
%      Pacific Standard).
%  tzname is the time zone name. "PST" for Pacific Standard Time.
%
%  if offset is a string, is it assumed to be the name of a station
%  (e.g. 'argus00') and the real offset and tzname are determined
%   from the database. tzname is omitted from the call.
% 
% NOTE: WaRNiNg: time is "epochtime". Always.
%
% 08/04/99: Extended by Stefan to operate on [m x 1] matrices
%
% 02/22/00: converted from Dutch to American
%           added "GMT" to the string to show timezone, also
%           to make it look more like a filename
%
% 03/07/00: changed from ctime.m to epoch2GMTString
% 03/07/00: and then to epoch2LocalString
%
% 04/22/03: changed : to _ in output. fixed argusOpt
%

% get days since 1970
time1970 = repmat(datenum('01-Jan-1970 00:00:00'),size(time)); 

% add offset
if nargin == 1
	offset = argusOpt( 'timeoffset' );
	if isempty(offset)
		error( 'No time offset available, please specify!');
	end
	tzname = argusOpt( 'timezonestring' );
	if isempty(tzname) & (offset==0)
		tzname = 'GMT';
	elseif isempty(tzname) & (offset~=0)
		error( 'No timezone name available, please specify!' );
	end

elseif nargin == 2

	if ischar(offset)
	    try
		[offset,tzname] = DBGetStationTZOffset(offset);
	    catch
		disp('No station TZ offset from database, using GMT');
		offset = 0; tzname = 'GMT';
	    end
	else
		error('No timezone name available, please specify!');
	end
end

time = time + offset*60;

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
	repmat(tzname,size(time)), ...	% tzname.
	repmat('.',size(time)), ...	% .
	str1(:,8:11)];			% 1998

str = strrep( str, ':', '_' );

%

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
%key support routines Argus CIL CIRN
%