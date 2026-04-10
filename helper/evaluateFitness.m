function fit = evaluateFitness(sol,map,start,goal)

if isempty(sol) || mod(length(sol),2) ~= 0
    fit = inf;
    return;
end

waypoints = reshape(sol,2,[])';
path = [start; waypoints; goal];

lengthCost = computeLength(sol,start,goal);
smoothCost = computeSmoothness(sol,start,goal);

collisionPenalty = computeCollision(path,map);
distPenalty = computeObstacleDistancePenalty(path,map);

if collisionPenalty > 0
    fit = 1e4 + lengthCost;
    return
end

fit = lengthCost ...
    + 20*smoothCost ...
    + 500*distPenalty;

end