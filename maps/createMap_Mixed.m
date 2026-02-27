function [map,start,goal] = createMap_Mixed()

gridSize = 100;
map = zeros(gridSize);

[X,Y] = meshgrid(1:gridSize);

% Rectangle
map(20:35,20:40) = 1;

% Circle
circle = (X-60).^2 + (Y-60).^2 < 10^2;
map(circle) = 1;

% Triangle
tri = inpolygon(X,Y,[70 85 75],[20 20 40]);
map(tri) = 1;

start = [5 5];
goal = [95 95];

end