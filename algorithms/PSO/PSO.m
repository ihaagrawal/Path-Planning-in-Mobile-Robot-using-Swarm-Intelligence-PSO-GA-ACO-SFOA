function [bestPath, metrics] = PSO(map,start,goal)

%% PARAMETERS
popSize = 30;
maxIter = 100;
numWaypoints = 4;

gridSize = size(map,1);
dim = numWaypoints*2;

w  = 0.7;
c1 = 1.5;
c2 = 1.5;

%% INITIALIZATION
pos = rand(popSize,dim)*gridSize;
vel = zeros(popSize,dim);

fitness = zeros(popSize,1);
for i = 1:popSize
    fitness(i) = evaluateFitness(pos(i,:),map,start,goal);
end

pBest = pos;
pBestFit = fitness;

[bestFitness,idx] = min(fitness);
gBest = pos(idx,:);

convergence = zeros(maxIter,1);

%% MAIN LOOP
for iter = 1:maxIter

    for i = 1:popSize

        r1 = rand(1,dim);
        r2 = rand(1,dim);

        vel(i,:) = w*vel(i,:) ...
            + c1*r1.*(pBest(i,:) - pos(i,:)) ...
            + c2*r2.*(gBest - pos(i,:));

        pos(i,:) = pos(i,:) + vel(i,:);
        pos(i,:) = max(min(pos(i,:),gridSize),1);

        newFit = evaluateFitness(pos(i,:),map,start,goal);

        if newFit < pBestFit(i)
            pBest(i,:) = pos(i,:);
            pBestFit(i) = newFit;
        end
    end

    [bestFitness,idx] = min(pBestFit);
    gBest = pBest(idx,:);
    convergence(iter) = bestFitness;
end

bestPath = gBest;

%% METRICS
metrics.pathLength = computeLength(gBest,start,goal);
metrics.smoothness = computeSmoothness(gBest,start,goal);
metrics.bestFitness = bestFitness;
metrics.meanFitness = mean(pBestFit);
metrics.stdFitness = std(pBestFit);
metrics.convergence = convergence;

end