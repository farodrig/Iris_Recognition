if ~exist('imgs', 'var')
    imgs = LoadFiles('DataSet');
end
if ~exist('centers', 'var') || ~exist('radios', 'var')
    run('carga_centros.m')
end
rects = cell(450,1);
for i = 1 : numel(imgs)
    rects{i} = makeRectangle(imgs{i}, centers(i,:), radios(i,:), 360, 30, 1);
end
save('rectangles72.mat','rects');