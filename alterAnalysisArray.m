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
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: alterAnalysisArray.m,v 1.1 2012/09/24 23:05:26 stanley Exp $
%
% $Log: alterAnalysisArray.m,v $
% Revision 1.1  2012/09/24 23:05:26  stanley
% Initial revision
%
%
%key 
%comment  
%
