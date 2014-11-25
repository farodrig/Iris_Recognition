if ~exist('rects', 'var')
    run('carga_rects.m')
end
codes = cell(450,1);
no_noise=cell(450,1);
for i = 1 : numel(rects)
    no_noise{i}=remove_noise(rects{i});
    codes{i} = createCode(no_noise{i});
end
save('codes_n1.mat','codes');%n1 xq se usa 1 gabor filter
