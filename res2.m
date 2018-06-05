function dq = res2(p, x, yDat)
% calculate residual for kInvertDepthModel.m. Called by LMFnlsq.m.
%
% Inputs
% p     n-vector of intital guess of parameters (h)
% x     m-vectors or matrix of independent variables (used as arg to
% func)(frequency*weight)
% yDat  m-vectors or matrix of data to be fit by func(x,p)
%
% Outputs
% dq   m-vector of residual

dq = kInvertDepthModel(p,x)- yDat;

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

