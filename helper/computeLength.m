function L = computeLength(sol,start,goal)

path = [start; reshape(sol,2,[])'; goal];
L = 0;

for i=1:size(path,1)-1
    L = L + norm(path(i+1,:) - path(i,:));
end

end