function [fs, kAlpha0, subvs, subXY, camUsed, lam1Norms, centerInds] = ...
                    prepareTilesShort(f, G, xy, cam, xm, ym, bathy)
%   [fs, kAlpha0, subvs, subXY, camUsed, lam1Norms, centerInds] = ...
%                   prepareTilesShort(f, G, xy, cam, xm, ym, bathy);
%
%  This routine replaces old code to find all the needed estimates for a
%  tile to be passed to csmInvertKAlpha. This starts by solving for the
%  dominant frequencies, then finding the first Fourier phase,
%  then a kAlpha initial seed, then potentially reducing the number of
%  pixels to an adaptive tile size of xy locations and the complex eigenvectors.
%  This versions is specific to short records, as defined by the parameter
%  shortLengthnFreqs which is the number of Fourier frequencies divided by
%  nKeep.   If less than shortLengthnFreqs, use this code (user action
%  required)
%  Inputs:
%   f       - list of all wave frequencies from the Fourier Transform
%   G       - Fourier transform for every pixel (wave band only)
%   xy      - Pixel xy locations
%   cam     - camera for each pixel
%   xm, ym  - analysis point for cBathy
%   bathy   - bathy structure (in process of being built up)
%  Outputs:
%   fs      - dominant frequencies, in priority order
%   kAlpha0 - seed values for k and Alpha for nlin search
%   subvs   - complex Fourier coefs, reduced to minimum size
%   subXY   - xy locations for subv
%   usedCam - camera used for this tile (dominant camera)
%   lam1Norms - for short records, this is the fourier magnitudes (for QC)
%   centerInds - index of the xy location closest to xm, ym, for phase
%                offset
%
%  This routine starts with the regular tile size specified by Lx, Ly, then
%  finds the dominant frequencies, then the Fourier magnitudes for each fs.  There 
%  are several steps along the way.  1.  If the tile lies on a camera seam,
%  it keeps only the dominant camera.  2.  It can't find an EOF so uses the 
%  raw Fourier coefficients for each fs, then estimates kSeed and aSeed for 
%  each.  3.  It reduces the tile size to kL times the length from kSeed 
%  (L = 2*pi/kSeed).  4. Finally it decimates if necessary down to maxNPix.  


kL = 1.0;         % fraction of expected wavelength for tile size
maxNPix = bathy.params.maxNPix;
nf = bathy.params.nKeep;
lam1Norms = nan(1,nf);
centerInds = nan(1,nf);
Lx = bathy.params.Lx;
Ly = bathy.params.Ly;
fB = f;                 % not using user choice of fs any more.

%% 1.  Start by finding the pixels that lie in the standard tile, size Lx 
%      by Ly.  If on a camera seam, keep only the dominant camera

idUse = find( (xy(:,1) >= xm-Lx) ...    % start with whole array
         &    (xy(:,1) <= xm+Lx) ...
         &    (xy(:,2) >= ym-Ly) ...
         &    (xy(:,2) <= ym+Ly) );

% if on seam, limit to the dominant camera by pixel count
cams = cam(idUse);
uniqueCams = unique(cams);
for i = 1: length(uniqueCams)
    N(i) = length(find(cams==uniqueCams(i)));
end
pick = [];
camUsed = -1;
if exist('N')
    [~,pickCam] = max(N);
    camUsed = uniqueCams(pickCam);
    pick = find(cams==camUsed);
end
% select only the dominant camera
subG = G(:,idUse(pick));
subxy = xy(idUse(pick),:);

%  quality control on size of available tile
minNPix = 16;       % require at least this many pixels
validTile = 0;         % default
if length(idUse(pick)) >= minNPix
    minSpanx = 2;          % require at least this timex dxm x coverage
    minSpany = 2;          % require at least this timex dym y coverage
    spanx = max(subxy(:,1))-min(subxy(:,1));
    spany = max(subxy(:,2))-min(subxy(:,2));
    if ((spanx >= minSpanx) && (spany >= minSpany))
        validTile = 1;
    end
end

if ~validTile       % toss small tiles along edges
    nada = nan(1,nf);
    fs = nada;          % use nan as an indicator of a failed f.
    kAlpha0 = nan(nf,2);
    subvs = [];
    subXY = [];
    lam1Norms = nada;
    
else        % try to find solutions
    %% 2.  Else find the dominant frequencies
    %  for short runs, fs are found in analyzeBathyCollect and are the same
    %  for every location.  lam1 is replaced by mean spectral power
    fs = squeeze(bathy.fDependent.fB(1,1,:));    
    lam1Norms = squeeze(bathy.fDependent.lam1(1,1,:));
    
%% 3.  For each frequency, find the kAlpha seeds 
    kAlpha0 = nan(length(fs),2);
    for i = 1: length(fs)
        indf = find(f==fs(i));
        v = subG(indf,:)';
        [kAlpha0(i,:), centerInds(i)] = findKAlphaSeed(subxy,v, xm, ym);
        
%% 4.  produce the adaptive tiles
        LxTemp = pi/kAlpha0(i,1) * kL;  % divide by 2 cuz tile is +/- Lx
        LyTemp = LxTemp*Ly/Lx;
        idUse = find( (subxy(:,1) >= xm-LxTemp) ...    
         &    (subxy(:,1) <= xm+LxTemp) ...
         &    (subxy(:,2) >= ym-LyTemp) ...
         &    (subxy(:,2) <= ym+LyTemp) );
        validTile = 0;      % default
        if length(idUse) >= minNPix
            spanx = max(subxy(:,1))-min(subxy(:,1));
            spany = max(subxy(:,2))-min(subxy(:,2));
            if ((spanx >= minSpanx) && (spany >= minSpany))
                validTile = 1;
            end
        end
        if validTile
            subvs{i} = v(idUse);
            subXY{i} = subxy(idUse,:);
%% finally, check if we need to decimate down to maxNPix then re-center
            del = max(1, length(idUse)/maxNPix);
            if del>1
                inds = round(1: del: length(subvs{i}));
                subvs{i} = subvs{i}(inds);
                subXY{i} = subXY{i}(inds,:);
                % re-compute the center index with fewer pixels
                xy = subXY{i};
                d = sqrt((xy(:,1) - xm).^2 + (xy(:,2)-ym).^2);
                [~,centerInds(i)] = min(d);
            end
        else
        	fs(i) = nan;
            subvs{i} = [];
            subXY{i} = [];
            lam1Norms(i) = nan;
        end
    end
end

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

