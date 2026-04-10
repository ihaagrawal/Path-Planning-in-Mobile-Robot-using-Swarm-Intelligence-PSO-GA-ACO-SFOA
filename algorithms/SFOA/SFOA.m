function [bestPath, metrics] = SFOA(map, start, goal)

%% PARAMETERS
popSize = 30;
maxIter = 100;
numWaypoints = 4;
gridSize = size(map,1);
alpha = 0.3;

%% INITIALIZATION
dim = numWaypoints * 2;
pop = rand(popSize, dim) * gridSize;
fitness = zeros(popSize,1);

for i = 1:popSize
    fitness(i) = evaluateFitness(pop(i,:), map, start, goal);
end

[bestFitness, bestIdx] = min(fitness);
bestSol = pop(bestIdx,:);
convergence = zeros(maxIter,1);

%% MAIN LOOP
for iter = 1:maxIter

    exploreProb = 1 - iter/maxIter;

    for i = 1:popSize

        if rand < exploreProb
            randIdx = randi(popSize);
            newSol = pop(i,:) + rand*(pop(randIdx,:) - pop(i,:));
        else
            newSol = pop(i,:) + alpha*(bestSol - pop(i,:));
        end

        if fitness(i) > mean(fitness)
            regenIdx = randi(dim,1,2);
            newSol(regenIdx) = rand(1,2)*gridSize;
        end

        newSol = max(min(newSol,gridSize),1);
        newFit = evaluateFitness(newSol, map, start, goal);

        if newFit < fitness(i)
            pop(i,:) = newSol;
            fitness(i) = newFit;
        end
    end

    [bestFitness, bestIdx] = min(fitness);
    bestSol = pop(bestIdx,:);
    convergence(iter) = bestFitness;
end

bestPath = bestSol;

%% METRICS
metrics.pathLength = computeLength(bestSol,start,goal);
metrics.smoothness = computeSmoothness(bestSol,start,goal);
metrics.bestFitness = bestFitness;
metrics.meanFitness = mean(fitness);
metrics.stdFitness = std(fitness);
metrics.convergence = convergence;

end