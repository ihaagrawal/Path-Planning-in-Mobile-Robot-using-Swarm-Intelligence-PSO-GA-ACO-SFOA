function [map,start,goal] = createMap_Triangle()

gridSize = 100;
map = zeros(gridSize);

[X,Y] = meshgrid(1:gridSize);

tri1 = inpolygon(X,Y,[20 40 30],[20 20 40]);
tri2 = inpolygon(X,Y,[60 80 70],[50 50 70]);

map(tri1 | tri2) = 1;

start = [5 5];
goal  = [95 95];

end