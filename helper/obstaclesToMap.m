function map = obstaclesToMap(obstacles, gridSize)

map = zeros(gridSize);

for i = 1:size(obstacles,1)
    x = round(obstacles(i,1));
    y = round(obstacles(i,2));
    w = round(obstacles(i,3));
    h = round(obstacles(i,4));

    xRange = max(1,x):min(gridSize,x+w);
    yRange = max(1,y):min(gridSize,y+h);

    map(xRange, yRange) = 1;
end

end