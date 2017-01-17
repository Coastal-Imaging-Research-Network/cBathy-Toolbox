function k = kInvertDepthModel(depth, fw)

% return wavenumber given depth and frequency

% include a weight too

w = fw(:,2);

k = dispsol(depth,fw(:,1),0);

k = k.*w;



%

% Copyright by Oregon State University, 2011

% Developed through collaborative effort of the Argus Users Group

% For official use by the Argus Users Group or other licensed activities.

%

% $Id: kInvertDepthModel.m,v 1.2 2012/09/24 23:24:48 stanley Exp $

%

% $Log: kInvertDepthModel.m,v $
% Revision 1.2  2012/09/24 23:24:48  stanley
% fix case in name
%

% Revision 1.1  2011/08/08 00:28:52  stanley

% Initial revision

%

%

%key whatever is right, do it

%comment  

%

