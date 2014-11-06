function img = LoadFiles (path)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    folders = dir(path);
    img = {};
    for i = 3:size(folders,1)
        if (folders(i).isdir)
            img = [img LoadImg(strcat(path, '/', folders(i).name, '/left/'), '*.bmp')];
            img = [img LoadImg(strcat(path, '/', folders(i).name, '/right/'), '*.bmp')];
        end
    end
end

