%% ============================
%% HELPER FUNCTIONS
%% ============================

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


function child = mutate(child,pm,gridSize)

for d = 1:length(child)

    if rand < pm
        child(d) = rand*gridSize;
    end

end

% bound control
child = max(min(child,gridSize),1);

end