function out_dir = driver_cbathy_Feb_2019(stackName,camera)
%
% This code will run a series of cBathy calls with different spatial and
% temporal resolutions. This code does not have high resolution camera
% imagery, *yet*, to for higher resolution inputs, we are literally
% subsampling the data and for temporal down sampling, we are taking every
% other image.
%
% This comes from an example m-file to demonstrate how to run cBathy and 
% display results.  It uses a supplied example data set and does not make
% assumptions about CIL conventions or databases.

out_dir = regexprep(stackName,'[^\\]*$','cBathyOutput\');


if ~exist(out_dir,'dir')
    mkdir(out_dir);
end

parameter_pairs.input_res = [5,10];
parameter_pairs.output_res = [10,25];
% parameter_pairs=[];

% Do a single cBathy analysis, returning the bathy structure (which you
% would normally save somewhere) and displaying the results.  
% stationStr = 'argusIR_IR';
stationStr = 'argus02b';

dt=1;
    %     for dt=1%[2,1]
    out_fmt = ['cBathy_input_AlongTrackTo800m_',camera,'output.mat'];
    run_SingleBathyRunNotCIL(stackName, stationStr,parameter_pairs,dt,out_dir,out_fmt);
    % save bathy data here!!!
%     out_name = sprintf('cBathy_input%.1fx%.1fm_output_%.1fx%.1fm_t%dHz.mat',parameter_pairs(c).input_res,parameter_pairs(c).output_res,dt);
%     out_name = regexprep(out_name,'\.0','');
%     save([out_dir,out_name],'bathy','parameter_pairs','dt');
        
    %     end
fprintf('Output files saved to %s\n',out_dir);
    

return



