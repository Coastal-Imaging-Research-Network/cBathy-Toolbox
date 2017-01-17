
function bathy = fixBathyTide( bathy)

%%
%
%  bathy = fixBathyTide(bathy);
%
%    fix the tide levels in a bathy. I.e., find the current 
% predicted or measured tide and subtract it from the h.
% This routine now accepts CIL compatible and non-compatible inputs.  If
% bathy.sName (the stack name) can be parsed successfully using
% parseFilename, use the tide function with two arguments, the station and
% the epoch.  This ensures that we can't mistakenly find tides from the
% wrong station (because the station name comes from the stack name).  If
% parseFilename fails, the user is responsible for ensuring they have
% supplied a correct tide function in params.tideFunction and only the
% epoch time is passed as an input.
%

%% Find estimated depths and tide correct, if tide data are available.
  
if (exist(bathy.params.tideFunction) ~= 2)   % existing function
	return;
end;

try
        foo = parseFilename(bathy.sName);
        if isempty(foo)         % not CIL compatible
            eval(['tide = ' bathy.params.tideFunction '(' bathy.epoch ');'])
        else    % CIL formatted stackname, hence CIL format tide function
            eval(['tide = ' bathy.params.tideFunction '(''' ...
                foo.station ''',' bathy.epoch ');'])
        end

	if(~isfield(bathy,'tide'))
		bathy.tide = tide;
		bathy.tide.zt = NaN;  % will correct with tide.zt later
	end;

	tidecorr = nansum( [bathy.tide.zt -1*tide.zt]);
	bathy.fDependent.hTemp = bathy.fDependent.hTemp + tidecorr;
	bathy.fCombined.h = bathy.fCombined.h + tidecorr;
	bathy.tide = tide;
end
	
