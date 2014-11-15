function canny_img=filter_edges(img)
canny_img = edge(img,'canny');
removeDir = [0;1];
% convolute with sobel masks
sobelX = [1, 0, -1; 2, 0, -2; 1, 0, -1];
sobelY = sobelX';
DxImg = conv2(img,sobelX,'same');
DyImg = conv2(img,sobelY,'same');
% for each canny-edge-pixel:
for lin = 1:size(img,1) % <-> y
    for col = 1:size(img,2) % <-> x
        if canny_img(lin,col)
            % normalize direction
            normDir = [DxImg(lin,col); DyImg(lin,col)];
            normDir = normDir / norm(normDir,2);
            % inner product
            innerP = normDir' * removeDir;
            % remove edge?
            if abs(innerP) <0.65  % 45° threshold
                canny_img(lin,col) = 0;
            end
        end
    end
end