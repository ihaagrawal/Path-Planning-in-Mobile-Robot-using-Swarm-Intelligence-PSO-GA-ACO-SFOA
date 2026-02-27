function penalty = computeObstacleDistancePenalty(path,map)

penalty = 0;

[obsX,obsY] = find(map==1);

for i=1:size(path,1)

    d = sqrt((obsX-path(i,1)).^2 + (obsY-path(i,2)).^2);
    minDist = min(d);

    penalty = penalty + 1/(minDist+1);

end

end