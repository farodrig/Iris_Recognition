function [ rect ] = makeMask(iris, centers, radios, L1, L2, type)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    BW = rgb2gray(iris);
    for i = 1:size(iris, 2)
        for j = 1:size(iris,1)
            if j<=L1(1,i) || j>=L2(1,i)
                BW(j, i) = 254;                
            end
        end
    end
    rect = makeRectangle(BW, centers, radios, 360, 30, type);
    rect(rect==254)=0;
    rect(rect>0)=255;
end

