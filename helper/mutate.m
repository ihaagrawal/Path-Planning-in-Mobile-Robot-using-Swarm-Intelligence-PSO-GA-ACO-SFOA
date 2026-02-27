function individual = mutate(individual, pm, gridSize)

% Mutation for waypoint vector
% individual = [x1 y1 x2 y2 ...]

for i = 1:length(individual)

    % mutate with probability pm
    if rand < pm

        % small gaussian perturbation
        individual(i) = individual(i) + randn * 5;

    end
end

% Bound control
individual = max(min(individual, gridSize), 1);

end