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
% Copyright by Oregon State University, 2011
% Developed through collaborative effort of the Argus Users Group
% For official use by the Argus Users Group or other licensed activities.
%
% $Id: listfDependentResultsForOnePoint.m,v 1.1 2012/09/24 23:25:19 stanley Exp $
%
% $Log: listfDependentResultsForOnePoint.m,v $
% Revision 1.1  2012/09/24 23:25:19  stanley
% Initial revision
%
%
%key 
%comment  
%
