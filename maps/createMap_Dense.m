function [start, goal, obstacles] = createMap_Dense()

start = [5, 5];
goal  = [95, 95];

obstacles = [];

rng(1);

for i = 1:25
    x = rand()*80 + 10;
    y = rand()*80 + 10;
    w = rand()*8 + 3;
    h = rand()*8 + 3;
    obstacles = [obstacles; x y w h];
end

end