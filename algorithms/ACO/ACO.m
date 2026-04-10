function [bestPath, metrics] = ACO(map, start, goal)

%% PARAMETERS
numAnts = 30;
maxIter = 100;
numWaypoints = 4;

gridSize = size(map,1);
dim = numWaypoints * 2;

alpha = 1;
rho   = 0.1;
Q     = 1;

%% INITIALIZATION
pheromone = ones(1, dim);
solutions = rand(numAnts, dim) * gridSize;
fitness   = zeros(numAnts,1);

bestFitness = inf;
bestSol = zeros(1,dim);

convergence = zeros(maxIter,1);

%% MAIN LOOP
for iter = 1:maxIter

    for i = 1:numAnts

        prob = pheromone.^alpha;
        prob = prob ./ sum(prob);

        newSol = zeros(1,dim);

        for d = 1:dim
            if rand < prob(d)
                newSol(d) = rand * gridSize;
            else
                newSol(d) = solutions(i,d);
            end
        end

        newSol = max(min(newSol,gridSize),1);

        fitness(i) = evaluateFitness(newSol, map, start, goal);
        solutions(i,:) = newSol;

        if fitness(i) < bestFitness
            bestFitness = fitness(i);
            bestSol = newSol;
        end
    end

    pheromone = (1 - rho) * pheromone;

    for i = 1:numAnts
        pheromone = pheromone + Q / (fitness(i) + 1e-6);
    end

    convergence(iter) = bestFitness;
end

bestPath = bestSol;

%% METRICS
metrics.pathLength  = computeLength(bestSol,start,goal);
metrics.smoothness  = computeSmoothness(bestSol,start,goal);
metrics.bestFitness = bestFitness;
metrics.meanFitness = mean(fitness);
metrics.stdFitness  = std(fitness);
metrics.convergence = convergence;

end