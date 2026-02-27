function penalty = computeCollision(path,map)

penalty = 0;

for i = 1:size(path,1)-1
    
    p1 = path(i,:);
    p2 = path(i+1,:);
    
    % Sample points along line
    numSamples = 50;
    
    xs = linspace(p1(1),p2(1),numSamples);
    ys = linspace(p1(2),p2(2),numSamples);
    
    for k = 1:numSamples
        
        x = round(xs(k));
        y = round(ys(k));
        
        if x<1 || y<1 || x>size(map,1) || y>size(map,2)
            penalty = 1;
            return;
        end
        
        safetyRadius = 3;   % tune this (2–5 recommended)

        xRange = max(1,x-safetyRadius):min(size(map,1),x+safetyRadius);
        yRange = max(1,y-safetyRadius):min(size(map,2),y+safetyRadius);
        
        if any(map(xRange,yRange),'all')
            penalty = 1;
            return;
        end
        
    end
end
end