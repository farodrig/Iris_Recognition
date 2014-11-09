function [ iris ] = isolateIris( iris, centers, radios )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    for x = 1:size(iris, 2)
        for y = 1:size(iris, 1)
            if (((centers(3)-x)^2 + (centers(4)-y)^2>radios(2)^2) || ((centers(1)-x)^2 + (centers(2)-y)^2<radios(1)^2))
                iris(y,x) = 255;
            end
        end
    end
end

