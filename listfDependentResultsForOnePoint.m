function listfDependentResultsForOnePoint(bathy, fDependent, x, y)
%   listBathyResults(bathy, fDependent, x, y)
%
% list cBathy values for any model location for debugging.
% fDependent is now valid only for a single location x,y.

disp([sprintf('\n\n') bathy.sName])
disp(['x = ' num2str(x) ', y = ' num2str(y)])
disp(' ')
disp('    fB    hTemp hTempErr  k    kErr     a     aErr  skill   dof')
disp('------------------------------------------------------------')
for n = 1: size(bathy.fDependent.hTemp, 3)
    str = sprintf('   %5.3f %6.2f %6.2f %6.3f %6.3f %6.2f %6.2f %6.2f %5.0f', ...
        fDependent.fB(n), ...
        fDependent.hTemp(n), ...
        fDependent.hTempErr(n), ...
        fDependent.k(n), ...
        fDependent.kErr(n), ...
        fDependent.a(n), ...
        fDependent.aErr(n), ...
        fDependent.skill(n), ...
        fDependent.dof(n));
    disp(str)
end
disp(sprintf('\n\n'))

% now fCombined
% str = sprintf('Combined %6.2f %6.2f', bathy.fCombined.h(i,j), ...
%         bathy.fCombined.hErr(i,j));
% disp(str)

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

