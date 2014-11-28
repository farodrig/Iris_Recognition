function [ lineUp, lineDown ] = getEyelidsLines( iris, centers, radios )
%	getEyelidsLines Entrega los puntos de las rectas de los parpados superior e inferior.
%   Entrega 2 rectas. La primera columna de cada recta corresponde a los
%   'x' del parpado, y la segunda columna al de los 'y' del parpado inferior.
    gray_iris = rgb2gray(iris);
    
    rowd = centers(4);
    cold = centers(3);
    rd = radios(2);
    
    irl = round(rowd-rd);
    icl = round(cold-rd);
    icu = round(cold+rd);

    rowp = centers(2);
    r = radios(1);

    topeyelid = gray_iris( irl:(rowp-r),icl:icu);
    lines = findline(topeyelid);

    if size(lines,1) > 0
        [xl, yl] = linecoords(lines, size(topeyelid));
        yl = double(yl) + irl-1;
        xl = double(xl) + icl-1;
    else
        xl = 1:size(gray_iris,2);
        yl = ones(1,size(gray_iris,2));        
    end
    xUp = xl;
    yUp = yl;
    izq = true;
    for i = [1:min(xl-1), max(xl+1):size(gray_iris,2)]
        if i > min(xl)
            izq = false;
        end
        if izq
            next = nextY(xUp(1)-1, xUp(2), yUp(2), xUp(1), yUp(1));
            xUp = [min(xUp)-1 xUp];
            yUp = [next yUp];
        else
            next = nextY(xUp(numel(xUp))+1, xUp(numel(xUp)), yUp(numel(yUp)), xUp(numel(xUp)-1), yUp(numel(yUp)-1));
            xUp = [xUp max(xUp)+1];
            yUp = [yUp next];
        end
    end
    lineUp = [yUp; xUp];
<<<<<<< HEAD
%     for i = 1:numel(yUp)
%         gray_iris(yUp(i), xUp(i)) = 255;
%     end

=======
    
    
>>>>>>> 169732c9d8803fb2492863d38a44d054776c2ec8
    bottomeyelid = gray_iris(max(irl, (rowp+r)):max((rowp-r), size(gray_iris,1)),icl:icu);
    lines = findline(bottomeyelid);
    if size(lines,1) > 0
        [xl, yl] = linecoords(lines, size(bottomeyelid));
        yl = round(double(yl)+ rowp+r-2);
        xl = round(double(xl) + icl-1);
    else
        xl = 1:size(gray_iris,2);
        yl = ones(1,size(gray_iris,2))*size(gray_iris,1);        
    end
    xDown = xl;
    yDown = yl;
    izq = true;
    for i = [1:min(xl-1), max(xl+1):size(gray_iris,2)]
        if i > min(xl)
            izq = false;
        end
        if izq
            next = nextY(xDown(1)-1, xDown(2), yDown(2), xDown(1), yDown(1));
            xDown = [min(xDown)-1 xDown];
            yDown = [next yDown];
        else
            next = nextY(xDown(numel(xDown))+1, xDown(numel(xDown)), yDown(numel(yDown)), xDown(numel(xDown)-1), yDown(numel(yDown)-1));
            xDown = [xDown max(xDown)+1];
            yDown = [yDown next];
        end
    end
    lineDown = [yDown; xDown];
<<<<<<< HEAD
%     for i = 1:numel(yDown)
%         gray_iris(yDown(i), xDown(i)) = 255;
%     end
    %imshow(gray_iris);
=======
>>>>>>> 169732c9d8803fb2492863d38a44d054776c2ec8
end

function [x,y] = linecoords(lines, imsize)
    xd = [1:imsize(2)];
    yd = (-lines(3) - lines(1)*xd ) / lines(2);

    coords = find(yd>imsize(1));
    yd(coords) = imsize(1);
    coords = find(yd<1);
    yd(coords) = 1;

    x = int32(xd);
    y = int32(yd);   
end

function yNew = nextY(x, x2, y2, x1, y1)
    yNew = round(((x-x1)/(x2-x1))*(y2-y1)+y1);
end
