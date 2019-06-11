% examineInputDataDemo
% example steps to look at the data that goes into the cBathy calculation
% that we just carried out.

% start by putting a breakpoint on the first line of code on
% analyzeSingleBathyRunNotCIL.m (line 20)

% then execute democBathy code.  It will stop at the breakpoint.

% step forward one line using the step button.  

whos        % note that the first line executes the settings file and 
            % you now have 'params' as a variable
params      % note it is just the input data that you set up.

% step forward another line and now you have loaded the stack

whos        % note t, xyz and data variables
t(1:5) - t(1)   % show 0.5 s sampling
t(end) - t(1)   % show length of record (shorted by 0.5 s)

plot(xyz(:,1), xyz(:,2), '.');  % show sampling array
xlabel('x (m)'); ylabel('y (m)')

plot(xyz(:,1), xyz(:,2));  % show array in the order it is store as columns
xlabel('x (m)'); ylabel('y (m)')

imagesc(data)       % number of rows = length of time, number of columns =
                    % number of xyz locations
                    % Waves can be seen but they are scrambled
                    
% step three lines forward and look at how bathy has been set up

bathy

% you could now continue and do the cBathy calculation but we have already
% done that.