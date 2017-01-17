function [subG, subXYZ] = spatialLimitBathy(G, xyz, xm, ym, params, kappa )

%% spatialLimitBathy -- extract appropriate data from stack for 
%   processing in the vicinity of xm, ym. 
%
% [subG, subXYZ] = spatialLimitBathy( f, G, xyz, xm, ym, params, kappa )
%

% these are the indices of xy data that are within our box
idUse = find( (xyz(:,1) >= xm-params.Lx*kappa) ...
	 &    (xyz(:,1) <= xm+params.Lx*kappa) ...
	 &    (xyz(:,2) >= ym-params.Ly*kappa) ...
	 &    (xyz(:,2) <= ym+params.Ly*kappa) );
del = max(1, length(idUse)/params.maxNPix);
idUse = idUse(round(1: del: length(idUse)));
subG = G(:,idUse);
subXYZ = xyz(idUse,:);

% problem: we've started getting subG's that came from missing data.
%  they are Inf because of the normalization in prepBathyInput, and they
%  mess up the EIG function in csmInvertKAlpha. Let's throw those columns
%  away. We may have no data (handled in subBathyProcess, or too little
%  data (handled in csmInvertKAlpha). 

% first, do we still have any data? 

if ~isempty(subG)
    
    [ugly, bad] = find(isnan(subG)); 
    all = 1:size(subG,2);
    good = setxor( all, unique(bad) );
    
    subG = subG(:,good);
    subXYZ = subXYZ(good,:);
    
end

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: spatialLimitBathy.m,v 1.2 2016/02/11 00:34:38 stanley Exp $
%
% $Log: spatialLimitBathy.m,v $
% Revision 1.2  2016/02/11 00:34:38  stanley
% toss bad data in subG
%
% Revision 1.1  2012/09/24 23:33:30  stanley
% Initial revision
%
%
%key 
%comment  
%
