function [ rectangle ] = makeRectangle(iris, centers, radios, length, width, type)
%Dada la imagen de un iris la rectangulariza
%   Type==1: sin filtro gaussiano
%   Type==2: con filtro gaussiano
    rectangle = zeros(width, length, 'uint8');
    img = isolateIris(rgb2gray(iris), centers, radios);
    center = [(centers(2)+centers(4))/2, (centers(1)+centers(3))/2];
    j=1;
    for theta = degtorad(linspace(0, 360, length))
        i = 1;
        [minrad, maxrad] = rangeIris(img, center, theta, [centers(3) centers(4)], radios(2));
        for r = linspace(minrad+1, maxrad-1, width)
            x = floor(center(1) + r*cos(theta));
            y = floor(center(2) + r*sin(theta));
            if type==1
                rectangle(i,j) = iris(x,y);
            elseif type==2
                rectangle(i,j) = gauss(iris, img, x , y);
            else
                error('Type dado no válida, solo acepta 1 o 2');
            end
            i = i+1;
        end
        j = j+1;
    end
end

function pixel = gauss(iris, img, x, y)
    mask = [1 2 1; 2 4 2; 1 2 1]/16;
    data = squareData(iris, img, x, y);
    pixel = uint8(sum(sum(mask.*data)));
end

function data = squareData(iris, img, x, y)
    data = iris(x-1:x+1, y-1:y+1);
    data2 = img(x-1:x+1, y-1:y+1);
    if data2(1,1)==255
        data(1,1) = data(1,3);
    end
    if data2(1,2)==255
        data(1,2) = data(3,2);
    end
    if data2(1,3)==255
        data(1,3) = data(1,1);
    end
    if data2(2,1)==255
        data(2,1) = data(2,3);
    end
    if data2(2,3)==255
        data(2,3) = data(2,1);
    end
    if data2(3,1)==255
        data(3,1) = data(3,3);
    end
    if data2(3,2)==255
        data(3,2) = data(1,2);
    end
    if data2(3,3)==255
        data(3,3) = data(1,3);
    end 
    data = double(data);
end

function [minr, maxr] = rangeIris(img, center, theta, center_iris, radio)
    minr = 0;
    maxr = 0;
    r = 1;
    while maxr == 0
        xNext = floor(center(1) + r*cos(theta));
        yNext = floor(center(2) + r*sin(theta));
        if (center_iris(1)-yNext)^2 + (center_iris(2)-xNext)^2>radio^2+2
            if minr==0
                minr = r-4;
            end
            maxr = r-3; 
            break;
        end
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