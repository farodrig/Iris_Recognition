if ~exist('imgs', 'var')
    imgs = LoadFiles('DataSet');
end
i = 327;
iris = imgs{i};
[center, radio] = segmentation(iris);
centers = [center(1,:) center(2,:)]; %Primer par es de la pupila, segundo par es el del iris.
radios = [radio(1) radio(2)];
rect = makeRectangle(iris, centers, radios, 360, 30, 2);
hold on; 
imshow(iris); 
viscircles(center, radio,'EdgeColor','b');
figure();
imshow(rect); 
hold off;