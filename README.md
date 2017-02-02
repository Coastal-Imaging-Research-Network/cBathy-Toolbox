# cBathy-Rob
 README for cBathy

When you type 'help {toolboxName}' where you insert your own toolbox
name, will give the Contents of the toolbox.
 
The outline below shows the order of how analysis routines are called.
 
This toolbox has been extacted from the full CIL version and SHOULD work
on a standalone basis.  In doing this, a number of checks have been removed
since these depend on CIL databases and standards.
 
Two demo files are provided as well as example data.  'democBathy' runs
the main cBathy processing to create phase 1 and 2 results (fDependent
and fCombined) and plots the results.  This is currently set to analyze 
a test data set, testStack102210Duck.mat, one used in the original cBathy 
paper in 2013.  'demoKalmanFiltering' takes an
example day of cBathy results and performs Kalman filtering, then plots
the results.  The set cBathy input data is constained  the folder 
102210cBathys and is again from an example from the 2013 paper.
NOTE that the results for the Kalman demo are stored in a
different location, simply for demo purposes (since many people may end
up using the toolbox).  Normally you would save the results back to the
input file location but now with the runningAverage field filled in. 
For comparison, the CRAB survey from three days prior is included in the 
file 19-Oct-2010FRFGridded.mat.
 
The first part (democBathy) needs only the stack information and the
tide, although if the tide is not found the routine should continue but
leave nans in the tide fields.  The Kalman stage needs a process error
routine specific to your site (findProcessError) and this usually needs
the wave height, H.  Adequate results can be found by guessing H, for
instance H = 1 m in this demo.  It makes no sense to Kalman filter if you
have not removed the tide (averaging a non-stationary signal).  The
toolbox contains a routine doKal.m which is a CIL version, included only to
illustrate the steps that we normally take.  Note the use of fixBathyTide
in Kalman filtering to make sure the tide has been compensated for.  If
tide has been fixed in a previous step, this routine will do no harm.
 
Note that the supplied example tide routine, fixBathyTide, is a CIL
routine that normally looks for two input arguments, the first of which
is the station name that we extract from the stack name (to ensure that
you can't possibly call the tide routine for an incorrect station).  If
the stack name is not standard, the routine will assume that this is not
a CIL station and will fall back to a single input argument version
(time), leaving the user responsible for chosing the correct tide
location.  
 
Please let us know if problems arise
[HERE](https://github.com/Coastal-Imaging-Research-Network/cBathy-Toolbox/issues)



Logicial Outline for analyzeBathyCollect version 2

- no tiles, each x,y done independently
- ie., csmInvertKAlpha does one x,y at a time, returns only fDependent

```
analyzeBathyCollect
input:  xyz, epoch, data  (data from stacks), bathy (with params)
output: bathy  (final results)

prepBathyInput( xyz, epoch, data, bathy )
output: f, G, bathy with empty data, allx, ally

parfor loop on allx, ally

subBathyProcess( f, G, xyz, ax, ay, params )
output: fDependent

spatialLimitBathy( f, G, xyz, params, ax, ay )
output: subG, subxyz

csmInvertKAlpha( f, subG, subxyz, ax, ay, params )
output: fDependent

stuff fDependent back into main bathy

end parfor

convert bathy fDependent to final output
```
