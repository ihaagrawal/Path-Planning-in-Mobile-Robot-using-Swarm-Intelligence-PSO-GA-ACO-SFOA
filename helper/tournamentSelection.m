function parent = tournamentSelection(pop,fitness)

popSize = size(pop,1);

idx1 = randi(popSize);
idx2 = randi(popSize);

if fitness(idx1) < fitness(idx2)
    parent = pop(idx1,:);
else
    parent = pop(idx2,:);
end

end