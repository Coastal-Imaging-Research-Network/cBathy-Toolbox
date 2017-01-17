function out = useInterpMap2( in, map, weight )

% function out = useInterpMap2( in, map, weight )
%
%   use the indices in the NxM array 'map' to remap the data in the Lx1
%   data array 'in' into an interpolated output 'out', with weights in the
%   NxM array "weight". 
%
%   map and weight are produced by findInterpMap2.
%

if isempty(map)
    warn('no map in input');
end

if isempty(weight)
    warn('no weighting array');
end

if (size(map) ~= size(weight))
    warn('map and weight must have same size!');
end


% must loop, until Rob can find an elegant way
out = in(map(:,1)) .* weight(:,1);
for ii = 2:size(map,2);
    out = out + in(map(:,ii)) .* weight(:,ii);
end

