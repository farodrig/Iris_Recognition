function [ rectangle ] = makeRectangle(iris, centers, radios, length, width)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    rectangle = zeros(width, length, 'uint8');
    img = isolateIris(iris, centers, radios);
    center = [(centers(2)+centers(4))/2, (centers(1)+centers(3))/2];
    j=1;
    for theta = degtorad(linspace(0, 360, length))
        i = 1;
        [minrad, maxrad] = rangeIris(img, center, theta);
        for r = linspace(minrad+1, maxrad-1, width)
            x = floor(center(1) + r*cos(theta));
            y = floor(center(2) + r*sin(theta));
            rectangle(i,j) = iris(x,y);
            i = i+1;
        end
        j = j+1;
    end
end

function [minr, maxr] = rangeIris(img, center, theta)
    minr = 0;
    maxr = 0;
    r = 1;
    while maxr == 0
        xNext = floor(center(1) + r*cos(theta));
        yNext = floor(center(2) + r*sin(theta));
        data = img(xNext, yNext);
        if (minr == 0 && data~=255)
            minr = r;
        end
        if (minr ~= 0 && data==255)
            maxr = r-1;
        end
        r = r+1;
    end
end