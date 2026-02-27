clc; clear; close all;

%% ADD PROJECT PATHS
addpath(genpath('algorithms'));
addpath(genpath('helper'));
addpath(genpath('maps'));

%% MAP LIST
mapFunctions = {
    @createMap_Rectangle
    @createMap_Triangle
    @createMap_Circle
    @createMap_Mixed
};

%% ALGORITHMS
algorithms = {@SFOA, @PSO, @GA, @ACO};
algoNames = {'SFOA','PSO','GA','ACO'};
algoColors = {'r','b','g','m'};

rng(1);

%% MAIN WINDOW
mainFig = figure( ...
    'Name','Algorithm Comparison', ...
    'NumberTitle','off', ...
    'Units','normalized', ...
    'Position',[0.05 0.05 0.9 0.85], ...
    'Color',[1 1 1]);

tabgroup = uitabgroup(mainFig);

%% LOOP MAPS
for k = 1:length(mapFunctions)

    [map,start,goal] = mapFunctions{k}();

    %% Create tab
    baseName = strrep(func2str(mapFunctions{k}),'createMap_','');
    tab = uitab(tabgroup,'Title',[baseName,' Obstacles']);

    %% ===============================
    %% MAP AXIS (TOP LEFT)
    %% ===============================

    axMap = axes(tab,'Units','normalized',...
        'Position',[0.00 0.39 0.60 0.55]);

    imagesc(axMap,map');
    colormap(axMap,[1 1 1;0 0 0]);
    axis(axMap,'equal','tight');
    set(axMap,'YDir','normal');
    hold(axMap,'on');

    hStart = plot(axMap,start(1),start(2),'go','MarkerSize',12,...
        'LineWidth',2,'MarkerFaceColor','g');

    hGoal = plot(axMap,goal(1),goal(2),'bo','MarkerSize',12,...
        'LineWidth',2,'MarkerFaceColor','b');

    %% RUN ALGORITHMS
    nAlgo = length(algorithms);
    pathHandles = gobjects(nAlgo,1);
    tableData = cell(nAlgo,4);

    pathLengths = zeros(nAlgo,1);
    runtimes = zeros(nAlgo,1);

    for a=1:nAlgo

        tic;
        [bestPath,metrics] = algorithms{a}(map,start,goal);
        runtime = toc;

        path = [start; reshape(bestPath,2,[])'; goal];

        pathHandles(a) = plot(axMap,...
            path(:,1),path(:,2),...
            algoColors{a},'LineWidth',3);

        pathLengths(a) = metrics.pathLength;
        runtimes(a) = runtime;

        tableData(a,:) = {
            algoNames{a},...
            round(metrics.pathLength,4),...
            round(metrics.smoothness,4),...
            round(runtime,4)
        };
    end

    title(axMap,[baseName,' Obstacles'],'FontSize',18,'FontWeight','bold');

    legend(axMap,[hStart hGoal pathHandles'],...
        [{'Start','Goal'},algoNames],...
        'Location','southoutside',...
        'Orientation','horizontal');

    %% ===============================
    %% METRIC TABLE (TOP RIGHT)
    %% ===============================

    uitable(tab,...
        'Data',tableData,...
        'ColumnName',{'Algorithm','Path Length','Smoothness','Runtime'},...
        'Units','normalized',...
        'Position',[0.55 0.55 0.40 0.22],...
        'FontSize',11);

    %% ===============================
    %% PATH LENGTH BAR GRAPH (BOTTOM LEFT)
    %% ===============================

    axBar1 = axes(tab,'Units','normalized',...
        'Position',[0.05 0.10 0.40 0.25]);

    bar(axBar1,pathLengths);
    set(axBar1,'XTickLabel',algoNames);
    title(axBar1,'Path Length Comparison');
    ylabel(axBar1,'Path Length');

    %% ===============================
    %% RUNTIME BAR GRAPH (BOTTOM RIGHT)
    %% ===============================

    axBar2 = axes(tab,'Units','normalized',...
        'Position',[0.55 0.10 0.40 0.25]);

    bar(axBar2,runtimes);
    set(axBar2,'XTickLabel',algoNames);
    title(axBar2,'Runtime Comparison');
    ylabel(axBar2,'Runtime (s)');

    %% ===============================
    %% BEST PERFORMER TEXT (BOTTOM CENTER)
    %% ===============================
    
    [~,bestLengthIdx] = min(pathLengths);
    
    uicontrol(tab,'Style','text',...
        'Units','normalized',...
        'Position',[0.25 0.03 0.50 0.04],...
        'String',{...
            ['Best Algorithm (Shortest Path): ',algoNames{bestLengthIdx}]},...
        'FontSize',13,...
        'FontWeight','bold',...
        'BackgroundColor',[1 1 1],...
        'HorizontalAlignment','center');

end