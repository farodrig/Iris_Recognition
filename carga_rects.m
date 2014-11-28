if ~exist('imgs', 'var')
    imgs = LoadFiles('DataSet');
end
if ~exist('centers', 'var') || ~exist('radios', 'var')
    run('carga_centros.m')
end
rects = cell(450,1);
for i = 1 : numel(imgs)
    lines=filterLines(imgs{i}, centers(i,:), radios(i,:));
    rects{i} = makeRectangle(lines, centers(i,:), radios(i,:), 360, 30, 1);
end
save('rectangles72.mat','rects');