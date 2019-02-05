function bathy = analyzeBathyCollect(xyz, epoch, data, cam, bathy, version)

%%
%
%  bathy = analyzeBathyCollect(xyz, epoch, data, cam, bathy[, version]);
%
%  cBathy main analysis routine.  Input data from a time
%  stack includes xyz, epoch and data as well as the initial fields
%  of the bathy structure.  Returns an
%  augmented structure with new fields 'fDependent' that contains all
%  the frequency dependent results and fCombined that contains the
%  estimated bathymetry and errors.
%  bathy input is expected to have fields .epoch, .sName and .params.
%  All of the relevant analysis parameters are contained in params.
%  These are usually set in an m-file (or text file) BWLiteSettings or
%  something similar that is loaded in the wrapper routine
%
%  'version' is an optional minimum required version. fail if not met.
%
%  NOTE - we assume a coordinate system with x oriented offshore for
%  simplicity.  If you use a different system, rotate your data to this
%  system prior to analysis then un-rotate after.

% test version
    myVer = cBathyVersion();
    if nargin == 6
        if( myVer < version ) 
            error(['This version: ' num2str(myVer) ' ...
                required version: ' num2str(version) ...
                ' FAIL!');
        end
    end

%% prepare data for analysis

[f, G, bathy] = prepBathyInput( xyz, epoch, data, bathy );

if( cBDebug( bathy.params, 'DOPLOTSTACKANDPHASEMAPS' ) )
    plotStacksAndPhaseMaps( xyz, epoch, data, f, G, bathy.params );
    input('Hit return to continue ')
    close(10); close(11);
end


%% now loop through all x's and y's

if( cBDebug( bathy.params, 'DOSHOWPROGRESS' ))
    figure(21);clf
    plot(xyz(:,1), xyz(:,2), '.'); axis equal; axis tight
    xlabel('x (m)'); ylabel('y (m)')
    title('Analysis Progress'); drawnow;
    hold on
end
str = [bathy.sName(16:21) ', ' bathy.sName(36:39) ', ' bathy.sName([23 24 26 27])];
if cBDebug( bathy.params )
	hWait = waitbar(0, str);
end;

for xind = 1:length(bathy.xm)
    if cBDebug( bathy.params )
	    waitbar(xind/length(bathy.xm), hWait)
    end;
    fDep = {};  %% local array of fDependent returns
    % kappa increases domain scale with cross-shore distance
    bathy.kappa = 1 + (bathy.params.kappa0-1)*(bathy.xm(xind) - min(xyz(:,1)))/ ...
        (max(xyz(:,1)) - min(xyz(:,1)));
    
    if( cBDebug( bathy.params, 'DOSHOWPROGRESS' ))
        for yind = 1:length(bathy.ym)
            [fDep{yind},camUsed(yind)] = subBathyProcess( f, G, xyz, cam, ...
                bathy.xm(xind), bathy.ym(yind), bathy );
        end
    else  
        parfor yind = 1:length(bathy.ym)
            [fDep{yind},camUsed(yind)] = subBathyProcess( f, G, xyz, cam, ...
                bathy.xm(xind), bathy.ym(yind), bathy );
        end  %% parfor yind
    end
    
    % stuff fDependent data back into bathy (outside parfor)
    for ind = 1:length(bathy.ym)
        
        bathy.camUsed(ind,xind) = camUsed(ind);
        
        if( any( ~isnan( fDep{ind}.k) ) )  % not NaN, valid data.
            bathy.fDependent.fB(ind, xind, :) = fDep{ind}.fB(:);
            bathy.fDependent.k(ind,xind,:) = fDep{ind}.k(:);
            bathy.fDependent.a(ind,xind,:) = fDep{ind}.a(:);
            bathy.fDependent.dof(ind,xind,:) = fDep{ind}.dof(:);
            bathy.fDependent.skill(ind,xind,:) = fDep{ind}.skill(:);
            bathy.fDependent.lam1(ind,xind,:) = fDep{ind}.lam1(:);
            bathy.fDependent.kErr(ind,xind,:) = fDep{ind}.kErr(:);
            bathy.fDependent.aErr(ind,xind,:) = fDep{ind}.aErr(:);
            bathy.fDependent.hTemp(ind,xind,:) = fDep{ind}.hTemp(:);
            bathy.fDependent.hTempErr(ind,xind,:) = fDep{ind}.hTempErr(:);
        end
        
    end
    
%     if( cBDebug( bathy.params, 'DOSHOWPROGRESS' ))
%         figure(21);
%         imagesc( bathy.xm, bathy.ym, bathy.fDependent.hTemp(:,:,1));
%     end
    
end % xind
if cBDebug( bathy.params )
	delete(hWait);
end;

%% Find estimated depths and tide correct, if tide data are available.
  
bathy = bathyFromKAlpha(bathy);

bathy = fixBathyTide(bathy);

%if ((exist(bathy.params.tideFunction) == 2))   % existing function
%    try
%        foo = parseFilename(bathy.sName);
%        eval(['tide = ' bathy.params.tideFunction '(''' ...
%            foo.station ''',' bathy.epoch ');'])
%        
%        bathy.tide = tide;
%        if( ~isnan( tide.zt ) ) 
%            bathy.fDependent.hTemp = bathy.fDependent.hTemp - tide.zt;
%            bathy.fCombined.h = bathy.fCombined.h - tide.zt;
%        end
%    end
%end

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

