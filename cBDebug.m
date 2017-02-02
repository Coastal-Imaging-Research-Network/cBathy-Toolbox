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

