if ~exist('imgs', 'var')
    imgs = LoadFiles('DataSet');
end
if ~exist('centers', 'var') || ~exist('radios', 'var')
    run('carga_centros.m')
end
rects = {};
for i = 1 : numel(imgs)
    rects{i} = makeRectangle(imgs{i}, centers(i,:), radios(i,:), 360, 35, 1);
end
save('rectangles.mat','rects');