% demo routine to examine the input data stack, used as first step in
% debugging.  Because stacks are arranged as a long list of pixel columns,
% we need to remap each row (sample time) into a spatial map then play hte
% frames as a movie.  This is done using findInterpMap and useInterpMap

clear
fn = 'testStack102210Duck.mat';
load(fn)
data = double(data);

% we need to design a pixel array that is comparable to the intended
% sampling array.  Plot the actual sampling array for a hint.
figure(1); clf
plot(xyz(:,1), xyz(:,2), '.')       % use this to determine a reasonable 
                                    % pixel array for mapping

% now find the mapping from pixel list to a reasonable map view
pa = [80 5 500 0 10 1000];          % design arrays
[x, y, map, wt] = findInterpMap(xyz,pa,[]);
Nx = length(x); Ny = length(y);

% now remap each row (sample time) of the stack and display as a movie
figure(2); clf; colormap(gray)
for i = 1: size(data,1)
    out = useInterpMap2(data(i,:)',map,wt); % first arg must be column
    imagesc(x,y,reshape(out, Ny, Nx));
    axis image; axis xy
    drawnow;
end

