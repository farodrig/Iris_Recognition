if ~exist('rects', 'var')
    run('carga_rects.m')
end
codes = cell(450,1);
mask=cell(450,1);
noise_mask=cell(450,1);
for i = 1 : numel(rects)
    mask{i}=remove_noise(rects{i});
    [codes{i}, noise_mask{i}]= createCode(rects{i},mask{i});
end
save('codes_n1.mat','codes');%n1 xq se usa 1 gabor filter
save('mask_n1.mat','noise_mask');
