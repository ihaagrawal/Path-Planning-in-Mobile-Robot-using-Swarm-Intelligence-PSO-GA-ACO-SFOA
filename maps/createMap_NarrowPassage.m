function [start, goal, obstacles] = createMap_NarrowPassage()

start = [5, 50];
goal  = [95, 50];

obstacles = [
    20 0 10 40;
    20 60 10 40;
    60 0 10 40;
    60 60 10 40;
];

end