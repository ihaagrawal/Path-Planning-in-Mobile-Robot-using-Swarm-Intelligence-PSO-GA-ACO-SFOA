clc; clear; close all;

set(0,'DefaultFigureWindowStyle','docked');
addpath(genpath(pwd));

%% PARAMETERS
numRuns = 5;

algorithms = {@SFOA, @PSO, @GA, @ACO};
algoNames  = ["SFOA","PSO","GA","ACO"];
colors     = {'r','b','g','m'};

%% MAP LIST
mapFunctions = {
    @createMap_Rectangle,      "Rectangle";
    @createMap_Triangle,       "Triangle";
    @createMap_Circle,         "Circle";
    @createMap_Mixed,          "Mixed";
    @createMap_NarrowPassage,  "Narrow";
    @createMap_Dense,          "Dense";
};

%% MAIN FIGURE WITH TABS
mainFig = figure( ...
    'Name','Path Planning Comparison', ...
    'Color',[0.1 0.1 0.1], ...
    'NumberTitle','off');

tabgp = uitabgroup(mainFig);

%% LOOP THROUGH MAPS
for m = 1:size(mapFunctions,1)

    mapFunc = mapFunctions{m,1};
    mapName = mapFunctions{m,2};

    fprintf('\nRunning %s...\n', mapName);

    %% LOAD MAP
    try
        out = cell(1,nargout(mapFunc));
        [out{:}] = mapFunc();

        if length(out)==3 && ismatrix(out{1}) && size(out{1},1)>10 && size(out{1},2)>10
            map   = out{1};
            start = out{2};
            goal  = out{3};
        else
            start     = out{1};
            goal      = out{2};
            obstacles = out{3};
            map       = obstaclesToMap(obstacles,100);
        end

    catch ME
        warning("Map failed: %s\nReason: %s", mapName, ME.message);
        continue;
    end

    numAlgos = length(algorithms);

    pathLengths = inf(numAlgos,1);
    smoothness  = inf(numAlgos,1);
    runtimes    = inf(numAlgos,1);
    efficiency  = inf(numAlgos,1);

    bestPaths = cell(numAlgos,1);

    %% RUN ALGORITHMS
    for a = 1:numAlgos

        totalLen    = 0;
        totalSmooth = 0;
        totalTime   = 0;
        validRuns   = 0;

        bestLen  = inf;
        bestPath = [];

        for r = 1:numRuns
            try
                tic;
                [path, ~] = algorithms{a}(map, start, goal);
                elapsedTime = toc;

                if isempty(path)
                    continue;
                end

                % Convert waypoint vector -> full path if needed
                if size(path,2) ~= 2
                    if mod(length(path),2) ~= 0
                        continue;
                    end
                    path = [start; reshape(path,2,[])'; goal];
                end

                if size(path,1) < 2
                    continue;
                end

                if size(path,1) > 2
                    sol = path(2:end-1,:);
                    sol = reshape(sol',1,[]);
                else
                    sol = [];
                end

                len = computeLength(sol, start, goal);
                sm  = computeSmoothness(sol, start, goal);

                if isnan(len) || isinf(len)
                    continue;
                end

                if computeCollision(path, map) > 0
                    continue;
                end

                totalLen    = totalLen + len;
                totalSmooth = totalSmooth + sm;
                totalTime   = totalTime + elapsedTime;
                validRuns   = validRuns + 1;

                if len < bestLen
                    bestLen  = len;
                    bestPath = path;
                end

            catch
                continue;
            end
        end

        if validRuns > 0
            pathLengths(a) = totalLen / validRuns;
            smoothness(a)  = totalSmooth / validRuns;
            runtimes(a)    = totalTime / validRuns;
            efficiency(a)  = pathLengths(a) * smoothness(a) * runtimes(a);
            bestPaths{a}   = bestPath;
        else
            bestPaths{a}   = [];
        end
    end

    %% BEST ALGORITHM
    finiteIdx = find(isfinite(pathLengths));
    if isempty(finiteIdx)
        bestAlgoText = 'Best Algorithm: None';
    else
        [~, relIdx] = min(pathLengths(finiteIdx));
        bestIdx = finiteIdx(relIdx);
        bestAlgoText = ['Best Algorithm: ' char(algoNames(bestIdx))];
    end

    %% TAB
    tab = uitab(tabgp, 'Title', char(mapName));

    %% AXES
    ax1 = axes('Parent', tab, 'Position', [0.05 0.58 0.42 0.33]); % map
    ax3 = axes('Parent', tab, 'Position', [0.06 0.10 0.38 0.30]); % path length
    ax4 = axes('Parent', tab, 'Position', [0.57 0.10 0.38 0.30]); % runtime

    %% MAP + PATHS
    hold(ax1,'on');
    imagesc(ax1, map');
    colormap(ax1, gray);
    set(ax1, ...
        'YDir','normal', ...
        'Color',[0.2 0.2 0.2], ...
        'XColor','w', ...
        'YColor','w', ...
        'FontSize',10);
    axis(ax1,[1 100 1 100]);
    axis(ax1,'equal');
    grid(ax1,'on');
    title(ax1, char(mapName) + " - Paths on Map", 'Color','w', 'FontWeight','bold');

    hStart = plot(ax1, start(1), start(2), 'go', 'MarkerFaceColor','g', 'MarkerSize',9);
    hGoal  = plot(ax1, goal(1), goal(2), 'bo', 'MarkerFaceColor','b', 'MarkerSize',9);

    legendHandles = [hStart hGoal];
    legendNames   = ["Start" "Goal"];

    validPlot = false;

    for a = 1:numAlgos
        p = bestPaths{a};
        if ~isempty(p) && size(p,1) > 1
            hp = plot(ax1, p(:,1), p(:,2), colors{a}, 'LineWidth', 2.5);
            plot(ax1, p(:,1), p(:,2), '.', 'Color', colors{a}, 'MarkerSize', 14);
            legendHandles(end+1) = hp; %#ok<AGROW>
            legendNames(end+1) = algoNames(a); %#ok<AGROW>
            validPlot = true;
        end
    end

    if ~validPlot
        text(ax1, 35, 50, 'No valid path found', ...
            'Color','w', 'FontSize',12, 'FontWeight','bold');
    end

    legend(ax1, legendHandles, legendNames, ...
        'TextColor','w', ...
        'Location','southoutside', ...
        'Orientation','horizontal', ...
        'Color',[0.1 0.1 0.1]);

    %% TABLE
    displayPathLengths = pathLengths;
    displaySmoothness  = smoothness;
    displayRuntimes    = runtimes;
    displayEfficiency  = efficiency;

    displayPathLengths(isinf(displayPathLengths)) = NaN;
    displaySmoothness(isinf(displaySmoothness))   = NaN;
    displayRuntimes(isinf(displayRuntimes))       = NaN;
    displayEfficiency(isinf(displayEfficiency))   = NaN;

    data = table(algoNames', displayPathLengths, displaySmoothness, ...
                 displayRuntimes, displayEfficiency, ...
        'VariableNames', {'Algorithm','PathLength','Smoothness','Runtime','Efficiency'});

    uitable('Parent', tab, ...
        'Data', data{:,:}, ...
        'ColumnName', data.Properties.VariableNames, ...
        'RowName', [], ...
        'Units', 'normalized', ...
        'Position', [0.56 0.56 0.38 0.34], ...
        'FontSize', 10);

    uicontrol('Parent', tab, ...
        'Style', 'text', ...
        'String', 'Comparison Table', ...
        'Units', 'normalized', ...
        'Position', [0.66 0.90 0.18 0.035], ...
        'BackgroundColor', [0.1 0.1 0.1], ...
        'ForegroundColor', 'w', ...
        'FontWeight', 'bold', ...
        'FontSize', 11);

    %% PATH LENGTH BAR
    vals1 = pathLengths;
    vals1(isinf(vals1)) = NaN;

    bar(ax3, vals1, 'FaceColor', [0.85 0.33 0.10]);
    title(ax3, 'Path Length Comparison', 'Color','w', 'FontWeight','bold');
    set(ax3, ...
        'XTick', 1:numAlgos, ...
        'XTickLabel', algoNames, ...
        'XColor','w', ...
        'YColor','w', ...
        'Color',[0.2 0.2 0.2], ...
        'FontSize',10);
    grid(ax3,'on');

    %% RUNTIME BAR
    vals2 = runtimes;
    vals2(isinf(vals2)) = NaN;

    bar(ax4, vals2, 'FaceColor', [0.47 0.67 0.19]);
    title(ax4, 'Runtime Comparison', 'Color','w', 'FontWeight','bold');
    set(ax4, ...
        'XTick', 1:numAlgos, ...
        'XTickLabel', algoNames, ...
        'XColor','w', ...
        'YColor','w', ...
        'Color',[0.2 0.2 0.2], ...
        'FontSize',10);
    grid(ax4,'on');

    %% BEST TEXT
    uicontrol('Parent', tab, ...
        'Style', 'text', ...
        'String', bestAlgoText, ...
        'Units', 'normalized', ...
        'Position', [0.38 0.01 0.25 0.045], ...
        'BackgroundColor', [0.1 0.1 0.1], ...
        'ForegroundColor', 'w', ...
        'FontWeight', 'bold', ...
        'FontSize', 12);
end