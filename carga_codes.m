if ~exist('rects', 'var')
    run('carga_rects.m')
end
codes = cell(450,1);
for i = 1 : numel(rects)
    codes{i} = createCode(rects{i});
end
save('codes_n1.mat','codes');%n1 xq se usa 1 gabor filter
