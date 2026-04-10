function sol = localRefine(sol, map, start, goal)

step = 2;

for i = 1:length(sol)

    best = sol;
    bestFit = evaluateFitness(sol, map, start, goal);

    for delta = [-step, step]
        temp = sol;
        temp(i) = temp(i) + delta;
        temp = max(min(temp, size(map,1)),1);

        f = evaluateFitness(temp, map, start, goal);

        if f < bestFit
            bestFit = f;
            best = temp;
        end
    end

    sol = best;
end

end