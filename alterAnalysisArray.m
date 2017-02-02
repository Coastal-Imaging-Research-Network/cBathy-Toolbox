function [xm,ym] = alterAnalysisArray(xm,ym)
%
%  [xm,ym] = alterAnalysisArray(xm,ym);
%
% allow user to alter the default xm, ym array to examine areas of
% interest.  Returns the xm, ym vectors  but with potentially altered xm,
% ym values  Users can enter a single point or min and max x and y values

fprintf('\nPlotPhaseTile Debug Mode:\nOpportunity to Alter Analysis Array\n\n')

fprintf('Current min, max, dx in x and y is %.0f %.0f %.0f  /  %.0f %.0f %.0f\n', ...
    min(xm),max(xm),mean(diff(xm)), min(ym),max(ym),mean(diff(ym)));
fprintf('\nPlease enter desired [xmin xmax dx ymin ymax dy], <CR> for no change \n')
f = input('');
if ~isempty(f)
    xm = [f(1): f(3): f(2)];
    ym = [f(4): f(6): f(5)];
    if((isempty(xm)) || (isempty(ym)))
        error('Invalid analysis array ')
    end
end

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

