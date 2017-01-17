% cBathy - routines to estimate bathymetry and wave variables from pixel data
%
%% Control Routines
%   democBathy          - example demo call to cBathy with display
%   analyzeSingleBathyRun - batch analysis for a single stackName
%   logic.txt           - work flow description for cBathy
%
%% Core Routines (not CIL specific)
% Primary Analysis Routines:
%   analyzeBathyCollect - single run cBathy analysis (parallel)
%   prepBathyInput      - prepare inputs for analysis
%   subBathyProcess     - extract and process an analysis point
%   csmInvertKAlpha     - main cBathy inversion routine for k-alpha
%   bathyFromKAlpha     - nonlinear solver for bathy from k-alpha
%   predictCSM          - xspectral matrix forward model for solver
%   findKAlphaPhiInit   - seed for nonlinear solver 
%   kInvertDepthModel   - used for bathy solver
%   fixBathyTide        - correct phase 1 and 2 estimates for tides
%   -- minor routines
%   cBDebug             - handler for debug calls
%   spatialLimitBathy   - part of tile processing
%   bathyCI             - helper to find confidence intervals
%
% Kalman Filtering:
%   makeKalmanBathySeed - initialize the first run for K-filtering
%   runningFilterBathy  - wrapper to Kalman filter a sequence of runs
%   KalmanFilterBathy   - core Kalman filter routine
%   findProcessError    - compute sensible process error
%
% Debugging and viewing
%   plotBathyCollect        - images of a single bathy and errors
%   plotBathyCollectKalman  - images of a Kalman-ed bathy and error
%   showcBathyTimeSeriesMovieNotCIL - movie of waves from non CIL stack
%   showHourlyBathyResults  - loop through a bathy sequence
%   showHourlyKalmanResults - loop through smooth sequence
%   plotStacksAndPhaseMaps  - debugMode displays for whole collect
%   listfDependentResultsForOnePoint - debugMode listing of fDependents
%   examineSingleBathyResult- display all variables for any bathy
%   plotBathyKalmanStep     - steps through runs showing all debug info
%   -- minor routines
%   cBDebug                 - debug call handling routine
%   alterAnalysisArray      - limit spatial data for debug
%   findGoodTransects       - helper routine in debugging
%   plotPhaseTile           - helper debug plot function
%
% Miscellaneous
%   epoch2Matlab            - convert time formats
%   matlab2Epoch            - inversion of above
%   dispsol                 - find linear wavenumber for any f, h
%   findInterpMap           - map for transforming stack to array
%   useInterpMap            - use the above
%
% CIL Batch Routines
%   cBathyBatch         - executes cBathy for a range of days
%   SETTINGS            - contains the params setting for each site
%   loadBathyStack      - load all cameras for a bathy stack
%   analyzeSingleBathyRunNOTCIL - batch analysis for non-CIL stack

%
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: Contents.m 190 2016-04-19 02:04:06Z stanley $
%
% $Log: Contents.m,v $
% Revision 1.2  2012/09/24 23:14:34  stanley
% updates, of course
%
% Revision 1.1  2011/08/08 00:28:51  stanley
% Initial revision
%
%
%key whatever is right, do it
%comment  
%
