function [bestPath, metrics] = SFOA(map, start, goal)

%% PARAMETERS
popSize = 30;
maxIter = 100;
numWaypoints = 1;
gridSize = size(map,1);
exploreProb = 0.5;
alpha = 0.3;

%% INITIALIZATION
dim = numWaypoints * 2;
pop = rand(popSize, dim) * gridSize;

fitness = zeros(popSize,1);

%% Evaluate initial population
for iter=1:maxIter
    
    exploreProb = 1 - iter/maxIter;   % adaptive exploration
    for i=1:popSize
        fitness(i) = evaluateFitness(pop(i,:), map, start, goal);
    end
end

[bestFitness, bestIdx] = min(fitness);
bestSol = pop(bestIdx,:);

convergence = zeros(maxIter,1);

%% MAIN LOOP
for iter=1:maxIter
    
    for i=1:popSize
        
        if rand < exploreProb
            % Exploration
            randIdx = randi(popSize);
            newSol = pop(i,:) + rand*(pop(randIdx,:) - pop(i,:));
        else
            % Exploitation
            newSol = pop(i,:) + alpha*(bestSol - pop(i,:));
        end
        
        % Regeneration
        if fitness(i) > mean(fitness)
            regenIdx = randi(dim,1,2);
            newSol(regenIdx) = rand(1,2)*gridSize;
        end
        
        % Bound control
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