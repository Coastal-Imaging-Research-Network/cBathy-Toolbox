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
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: findGoodTransects.m,v 1.1 2011/08/08 00:28:51 stanley Exp $
%
% $Log: findGoodTransects.m,v $
% Revision 1.1  2011/08/08 00:28:51  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
