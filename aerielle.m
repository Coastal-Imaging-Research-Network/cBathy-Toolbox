%%% Site-specific Inputs
params.stationStr = 'aerielle';
params.dxm = 10;                    % analysis domain spacing in x
params.dym = 25;                    % analysis domain spacing in y
params.xyMinMax = [80 500 500 700];   % min, max of x, then y
                                    % default to [] for cBathy to choose
params.tideFunction = 'cBathyTide';  % tide level function for evel

%%%%%%%   Power user settings from here down   %%%%%%%
params.MINDEPTH = 0.25;             % for initialization and final QC
params.minValsForBathyEst = 4;      % min num f-k pairs for bathy est.

params.QTOL = 0.5;                  % reject skill below this in csm
params.minLam = 10;                 % min normalized eigenvalue to proceed
params.Lx = 2*params.dxm;           % tomographic domain smoothing
params.Ly = 2*params.dym;           % 
params.kappa0 = 2;                  % increase in smoothing at outer xm
params.DECIMATE = 1;                % decimate pixels to reduce work load.
params.maxNPix = 80;                % max num pixels per tile (decimate excess)

% f-domain etc.
params.fB = [1/18: 1/50: 1/4];		% frequencies for analysis (~40 dof)
params.nKeep = 4;                   % number of frequencies to keep

% debugging options
params.debug.production = 0;
params.debug.DOPLOTSTACKANDPHASEMAPS = 1;  % top level debug of phase
params.debug.DOSHOWPROGRESS = 1;		  % show progress of tiles
params.debug.DOPLOTPHASETILE = 1;		  % observed and EOF results per pt
params.debug.TRANSECTX = 200;		  % for plotStacksAndPhaseMaps
params.debug.TRANSECTY = 600;		  % for plotStacksAndPhaseMaps

% default offshore wave angle.  For search seeds.
params.offshoreRadCCWFromx = 0;

% choose method for non-linear fit
params.nlinfit = 0; % flag, 0 = use LMFnlsq.m to do non-linear fitting
                    %       1 = use Matlab Statistics and computer vision
                    %       toolbox nlinfit.m 

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

