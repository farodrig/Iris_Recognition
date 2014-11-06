imgs = LoadFiles('DataSet');
centers = zeros(size(imgs,2), 4);
radios = zeros(size(imgs,2), 2);
for i = 1:size(imgs,2)
    [center, radio] = segmentation(imgs{i});
    centers(i,:) = [center(1,:) center(2,:)]; %Primer par es de la pupila, segundo par es el del iris.
    radios(i,:) = [radio(1) radio(2)];
end
save(centers,'centers');
save(radios,'radios');