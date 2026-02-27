function S = computeSmoothness(sol,start,goal)

path = [start; reshape(sol,2,[])'; goal];
S = 0;

for i=2:size(path,1)-1
    v1 = path(i,:) - path(i-1,:);
    v2 = path(i+1,:) - path(i,:);
    angle = acos(dot(v1,v2)/(norm(v1)*norm(v2)+eps));
    S = S + abs(angle);
end

end