function fit = evaluateFitness(sol,map,start,goal)

% Build full path
path = [start; reshape(sol,2,[])'; goal];

%% -------------------------------
%% COST COMPONENTS
%% -------------------------------

lengthCost = computeLength(sol,start,goal);
smoothCost = computeSmoothness(sol,start,goal);

collisionPenalty = computeCollision(path,map);

distPenalty = computeObstacleDistancePenalty(path,map);

%% -------------------------------
%% HARD CONSTRAINT FOR COLLISIONS
%% -------------------------------

% If ANY collision → massive penalty
if collisionPenalty > 0

    % make colliding solutions unusable
    fit = 1e6 + lengthCost;

    return
end

%% -------------------------------
%% FINAL FITNESS
%% -------------------------------

fit = lengthCost ...
    + 20*smoothCost ...
    + 500*distPenalty;

end