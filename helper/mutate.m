function individual = mutate(individual, pm, gridSize)

for i = 1:length(individual)
    if rand < pm
        individual(i) = individual(i) + randn * 5;
    end
end

individual = max(min(individual, gridSize), 1);

end