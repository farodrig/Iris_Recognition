function [ centers, radius ] = segmentation(iris)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    img = rgb2gray(iris);    
    BW = edge(img,'canny');
    [centersPupil, radiiPupil, ~] = imfindcircles(BW,[20 40], 'method', 'TwoStage', 'EdgeThreshold',0.2);
    [centersIris, radiiIris, ~] = imfindcircles(BW,[43 73], 'method', 'TwoStage', 'EdgeThreshold',0.2);
    center = [size(img,1)/2, size(img,2)/2];
    if(numel(centersIris)>2)
        min = 5000;
        for i = 1:size(centersIris,1)
            dist = distanceEuc(centersIris(i,1), centersIris(i,2), center(1), center(2));
            if dist<min
                candcen = centersIris(i,:);
                candrad = radiiIris(i);
            end
        end
        centersIris = candcen;
        radiiIris = candrad;
    end    
    while(numel(centersPupil)>2)
        index = [];
        for i = 1:size(centersPupil,1)
            if ~(insideCircle(centersIris(1,:), radiiIris(1), centersPupil(i,:), radiiPupil(i)))
                index = [index i];
            end
        end
        [centersPupil, ~] = removerows(centersPupil,'ind', index);
        [radiiPupil, ~] = removerows(radiiPupil,'ind', index);
        min = 5000;
        for i = 1:size(centersPupil,1)
            dist = distanceEuc(centersPupil(i,1), centersPupil(i,2), center(1), center(2));
            if dist<min
                min = dist;
                candcen = centersPupil(i,:);
                candrad = radiiPupil(i);
            end
        end
        centersPupil = candcen;
        radiiPupil = candrad;
    end
    
    centers = [centersPupil; centersIris];
    radius = [radiiPupil; radiiIris];
    
    function dist = distanceEuc(x1, y1, x2, y2)
        dist = sqrt((x2-x1)^2+(y2-y1)^2);
    end

    function bool = insideCircle(center1, rad1, center2, rad2)
        distance = distanceEuc(center1(1), center1(2), center2(1), center2(2));
        bool = distance>0 && distance<abs(rad1 - rad2);
    end
end

