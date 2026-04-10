function [bestPath, metrics] = GA(map,start,goal)

%% PARAMETERS
popSize = 30;
maxIter = 100;
numWaypoints = 4;

gridSize = size(map,1);
dim = numWaypoints*2;

pc = 0.8;
pm = 0.1;

%% INITIALIZATION
pop = rand(popSize,dim)*gridSize;
fitness = zeros(popSize,1);

for i = 1:popSize
    fitness(i) = evaluateFitness(pop(i,:),map,start,goal);
end

convergence = zeros(maxIter,1);

%% MAIN LOOP
for iter = 1:maxIter

    newPop = zeros(size(pop));

    for i = 1:2:popSize

        p1 = tournamentSelection(pop,fitness);
        p2 = tournamentSelection(pop,fitness);

        if rand < pc
            cp = randi(dim-1);
            child1 = [p1(1:cp) p2(cp+1:end)];
            child2 = [p2(1:cp) p1(cp+1:end)];
        else
            child1 = p1;
            child2 = p2;
        end

        child1 = mutate(child1,pm,gridSize);
        child2 = mutate(child2,pm,gridSize);

        newPop(i,:) = child1;
        if i+1 <= popSize
            newPop(i+1,:) = child2;
        end
    end

    pop = newPop;

    for i = 1:popSize
        fitness(i) = evaluateFitness(pop(i,:),map,start,goal);
    end

    [bestFitness,bestIdx] = min(fitness);
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