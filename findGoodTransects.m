function [xInd, yInd] = findGoodTransects(xyz, params)
%
%   [xInd, yInd] = findGoodTransects(xyz, params)
%
%  pick out the indices of a representative x and y transect from a
%  matrix set of pixel locations, xyz.  Used for plotting
%  cross-spectra for BWLite.

medX = median(xyz(:,1)); medY = median(xyz(:,2));

if( nargin < 2 )
       params.debug.frank = 0;
end

if( isfield( params.debug, 'TRANSECTX' ) )
    medX = params.debug.TRANSECTX;
end
if( isfield( params.debug, 'TRANSECTY' ) )
    medY = params.debug.TRANSECTY;
end

delx = sqrt(prod(max(xyz(:,1:2)) - min(xyz(:,1:2)))/(2*size(xyz,1)));
dely = 2*delx;      % default 2:1 y:x spacing.

% get representative x-profile
dY = xyz(:,2)-medY;
idy = find(abs(dY)<dely);
[sortx, xsortid] = sort(xyz(idy,1));
idy = idy(xsortid);
diffx = diff(xyz(idy,1)); bad = find(diffx<0.4*delx);
while any(bad)
    for i = 1: length(bad)
        [foo,bar] = max(abs(dY(idy([bad(i) bad(i)+1]))));
        toss(i) = bar+bad(i)-1;
    end
    idy = setdiff(idy, idy(toss));
    [sortx, xsortid] = sort(xyz(idy,1));
    idy = idy(xsortid);
    diffx = diff(xyz(idy,1)); bad = find(diffx<0.4*delx);
    clear toss
end
xInd = idy;

% get representative y-profile
clear toss;
dX = xyz(:,1)-medX;
idy = find(abs(dX)<delx);
[sortx, xsortid] = sort(xyz(idy,2));
idy = idy(xsortid);
diffy = diff(xyz(idy,2)); bad = find(abs(diffy)<0.4*dely);
while any(bad)
    for i = 1: length(bad)
        [foo,bar] = max(abs(dX(idy([bad(i) bad(i)+1]))));
        toss(i) = bar+bad(i)-1;
    end
    idy = setdiff(idy, idy(toss));
    [sortx, xsortid] = sort(xyz(idy,2));
    idy = idy(xsortid);
    diffy = diff(xyz(idy,2)); bad = find(abs(diffy)<0.4*dely);
    clear toss
end
yInd = idy;

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

