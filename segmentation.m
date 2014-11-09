function [ centers, radius ] = segmentation(iris)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    img = rgb2gray(iris);    
    BW = edge(img,'canny');
    irisLimits = [20 37 35 73; 20 37 30 73; 20 39 40 73];
    centersPupil = [];
    centersIris = [];
    l = 1;
    while (isempty(centersPupil) || isempty(centersIris))
        if (l>size(irisLimits,1))
            centersPupil = [0 0];
            centersIris = [0 0];
            radiiPupil = 0;
            radiiIris = 0;
            break;
        end
        [centersPupil, radiiPupil, ~] = imfindcircles(BW,[irisLimits(l,1) irisLimits(l,2)], 'method', 'TwoStage', 'EdgeThreshold',0.2);
        [centersIris, radiiIris, ~] = imfindcircles(BW,[irisLimits(l,3) irisLimits(l,4)], 'method', 'TwoStage', 'EdgeThreshold',0.2);
        if (isempty(centersPupil) || isempty(centersIris))
            l = l+1;
            continue;
        end
        center = [size(img,1)/2, size(img,2)/2];
        if(numel(centersIris)>2)
            min = 5000; cont = 0;
            for i = 1:size(centersIris,1)
                dist = distanceEuc(centersIris(i,1), centersIris(i,2), center(1), center(2));
                if dist<min && countInsideCircle(centersIris(i,:), radiiIris(i), centersPupil, radiiPupil)>0
                    cont = cont+1;
                    min = dist;
                    candcen = centersIris(i,:);
                    candrad = radiiIris(i);
                end
            end
            if cont~=0
                centersIris = candcen;
                radiiIris = candrad;
            end
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
            min = 5000; cont = 0;
            for i = 1:size(centersPupil,1)
                dist = distanceEuc(centersPupil(i,1), centersPupil(i,2), center(1), center(2));
                if dist<min
                    cont = cont+1;
                    min = dist;
                    candcen = centersPupil(i,:);
                    candrad = radiiPupil(i);
                end
            end
            if cont~=0
                centersPupil = candcen;
                radiiPupil = candrad;
            end
        end
        l = l+1;
    end
    %centersPupil = [centersPupil(2), centersPupil(1)];
    %centersIris = [centersIris(2), centersIris(1)];
    centers = [centersPupil; centersIris];
    radius = [radiiPupil; radiiIris];
    
    function dist = distanceEuc(x1, y1, x2, y2)
        dist = sqrt((x2-x1)^2+(y2-y1)^2);
    end

    function bool = insideCircle(center1, rad1, center2, rad2)
        distance = distanceEuc(center1(1), center1(2), center2(1), center2(2));
        bool = distance>0 && distance<abs(rad1 - rad2);
    end

    function count = countInsideCircle(center, rad, centers, radios)
        count = 0;
        for n = 1:size(centers, 1)
            if insideCircle(center, rad, centers(n,:), radios(n))
                count = count + 1;
            end
        end
    end
end

