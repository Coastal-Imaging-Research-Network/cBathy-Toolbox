function out_fn = democBathyVersion2p0
% Demo Run of cBathy :
%
% This code will run cBathy on a sample data set located in subfolder 
% "DemoData".  Both this function and the DemoData subfolder must be stored
% in the directory containing v2.0 cBathy code.
% 
% The sample case is from August 8, 2015, from the Argus system at Duck,
% NC.
% 
% This example m-file demonstrates how to run cBathy and display results.  
% It uses a supplied example data set and does not make assumptions about 
% CIL conventions or databases.

% demo data: Find the sample file:
data_stackPnStr=fullfile('DemoData','1439053140.Sat.Aug.08_16_59_00.GMT.2015.argus02b.cx.mBW.mat');

% output directory and file name:
out_dir = 'NewDemoTest';
out_name = 'cBathyOutput_Demo.mat';
if ~exist(out_dir,'dir')
    mkdir(out_dir);
end

% Input parameter file:
stationStr = 'argus02b';
eval(stationStr)        % creates the params structure.

% load the input data set
load(data_stackPnStr)

% create the bathy output structure and start populating it
bathy.epoch = num2str(T(1));
bathy.sName = data_stackPnStr;
bathy.params = params;

% Run cBathy
bathy = analyzeBathyCollect(XYZ, T, RAW, CAM, bathy);

% save the cBathy result
out_fn = fullfile(out_dir,out_name);
save(out_fn,'bathy');

fprintf('Output files saved to %s\n',out_dir);

% display bathy data:
figure;
pcolor(bathy.xm,bathy.ym,bathy.fCombined.h);
shading flat;
colormap(flipud(jet))
colorbar
caxis([0,10])
xlabel('X(m)');
ylabel('Y(m)')
title('Demo from Aug. 8, 2020')
axis('equal','tight');
xlim([100,500])
ylim([0,1000])
set(gca,'FontSize',12);

return



