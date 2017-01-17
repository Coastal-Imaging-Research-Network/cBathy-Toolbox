function fDep = subBathyProcess( f, G, xyz, xm, ym, params, kappa )

%% subBathyProcess -- extract region from full bathy stack, process
%
%  fDep = subBathyProcess( f, G, xyz, xm, ym, params, kappa )
%
%  f, G, xyz are the full arryms. 
%  xm,ym is the desired analysis point.
%  params is the parameter structure
%  kappa is the cross-shore variable sample domain scaling factor for this
%       position
%

%% first extract sub region

[subG, subXYZ] = spatialLimitBathy( G, xyz, xm, ym, params, kappa );
if( cBDebug( params, 'DOSHOWPROGRESS' ))
    figure(21);
    foo = findobj('tag','pixDots'); % tidy up old locations
    if ~isempty(foo)
        delete(foo)
    end
    foo = findobj('tag','xmDot');
    if ~isempty(foo)
        delete(foo)
    end
    hp1 = plot(subXYZ(:,1), subXYZ(:,2), 'r.', 'tag', 'pixDots');
    hp2 = plot(xm, ym, 'g.', 'tag', 'xmDot');
end


%% anything to process?

if isempty(subG)
	fDep.k = nan(params.nKeep,1);
	return;
end

%% now process!

fDep = csmInvertKAlpha( f, subG, subXYZ, xm, ym, params, kappa );

%% how simple!

 

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: subBathyProcess.m,v 1.1 2012/09/24 23:33:57 stanley Exp $
%
% $Log: subBathyProcess.m,v $
% Revision 1.1  2012/09/24 23:33:57  stanley
% Initial revision
%
%
%key 
%comment  
%
