function [map,start,goal] = createMap_Circle()

gridSize = 100;
map = zeros(gridSize);

[X,Y] = meshgrid(1:gridSize);

circle1 = (X-40).^2 + (Y-40).^2 < 10^2;
circle2 = (X-70).^2 + (Y-20).^2 < 12^2;

map(circle1 | circle2) = 1;

start = [5 5];
goal = [95 95];

end