function img_lines=filterLines(img,center,radio)
    img_lines=rgb2gray(img);
    %img_lines=img;
    [lineup, linedown]=getEyelidsLines(img,center,radio);
    for i=1:size(img,1)
        for j=1:size(img,2)
            if isnan(img_lines(i,j))
                continue
            end
            if i<=lineup(1,j) || i>linedown(1,j)
                img_lines(i,j)=NaN;
            end
        end
    end
end