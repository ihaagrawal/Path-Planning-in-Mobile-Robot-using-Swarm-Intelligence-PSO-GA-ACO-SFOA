function [map,start,goal] = createMap_Rectangle()

gridSize = 100;
map = zeros(gridSize);

rects = [
    20 20 20 10;
    50 40 15 30;
    70 10 20 15
];

for i = 1:size(rects,1)
    x = rects(i,1);
    y = rects(i,2);
    w = rects(i,3);
    h = rects(i,4);
    map(x:min(x+w,gridSize), y:min(y+h,gridSize)) = 1;
end

start = [5 5];
goal  = [95 95];

end