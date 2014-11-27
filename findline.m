% findline - returns the coordinates of a line in an image using the
% linear Hough transform and Canny edge detection to create
% the edge map.
%
% Usage: 
% lines = findline(image)
%
% Arguments:
%	image   - the input image
%
% Output:
%	lines   - parameters of the detected line in polar form
%
% Author: 
% Libor Masek
% masekl01@csse.uwa.edu.au
% School of Computer Science & Software Engineering
% The University of Western Australia
% November 2003

function lines = findline(image)
    [I2, or] = canny(image, 2, 1, 0.00, 1.00);

    I3 = adjgamma(I2, 1.9);
    I4 = nonmaxsup(I3, or, 1.5);
    edgeimage = hysthresh(I4, 0.20, 0.15);

    theta = (0:179)';
    [R, xp] = radon(edgeimage, theta);

    maxv = max(max(R));

    if maxv > 25
        i = find(R == max(max(R)));
    else
        lines = [];
        return;
    end

    [~, ind] = sort(-R(i));
    u = size(i,1);
    k = i(ind(1:u));
    [y,x]=ind2sub(size(R),k);
    t = -theta(x)*pi/180;
    r = xp(y);

    lines = [cos(t) sin(t) -r];

    cx = size(image,2)/2-1;
    cy = size(image,1)/2-1;
    lines(:,3) = lines(:,3) - lines(:,1)*cx - lines(:,2)*cy;
end

function [gradient, or] = canny(im, sigma, scaling, vert, horz)

    xscaling = vert;
    yscaling = horz;

    hsize = [6*sigma+1, 6*sigma+1];   % The filter size.

    gaussian = fspecial('gaussian',hsize,sigma);
    im = filter2(gaussian,im);        % Smoothed image.

    im = imresize(im, scaling);

    [rows, cols] = size(im);

    h =  [  im(:,2:cols)  zeros(rows,1) ] - [  zeros(rows,1)  im(:,1:cols-1)  ];
    v =  [  im(2:rows,:); zeros(1,cols) ] - [  zeros(1,cols); im(1:rows-1,:)  ];
    d1 = [  im(2:rows,2:cols) zeros(rows-1,1); zeros(1,cols) ] - ...
                                   [ zeros(1,cols); zeros(rows-1,1) im(1:rows-1,1:cols-1)  ];
    d2 = [  zeros(1,cols); im(1:rows-1,2:cols) zeros(rows-1,1);  ] - ...
                                   [ zeros(rows-1,1) im(2:rows,1:cols-1); zeros(1,cols)   ];

    X = ( h + (d1 + d2)/2.0 ) * xscaling;
    Y = ( v + (d1 - d2)/2.0 ) * yscaling;

    gradient = sqrt(X.*X + Y.*Y); % Gradient amplitude.

    or = atan2(-Y, X);            % Angles -pi to + pi.
    neg = or<0;                   % Map angles to 0-pi.
    or = or.*~neg + (or+pi).*neg; 
    or = or*180/pi;               % Convert to degrees.
end

function newim = adjgamma(im, g)

    if g <= 0
	error('Gamma value must be > 0');
    end

    if isa(im,'uint8');
	newim = double(im);
    else 
	newim = im;
    end
    	
    % rescale range 0-1
    newim = newim-min(min(newim));
    newim = newim./max(max(newim));
    
    newim =  newim.^(1/g);   % Apply gamma function
end

function im = nonmaxsup(inimage, orient, radius)
    if size(inimage) ~= size(orient)
      error('image and orientation image are of different sizes');
    end

    if radius < 1
      error('radius must be >= 1');
    end

    [rows,cols] = size(inimage);
    im = zeros(rows,cols);        % Preallocate memory for output image for speed
    iradius = ceil(radius);

    % Precalculate x and y offsets relative to centre pixel for each orientation angle 

    angle = 0:180;
    angle = angle.*pi/180; % Array of angles in 1 degree increments (but in radians).
    xoff = radius*cos(angle);   % x and y offset of points at specified radius and angle
    yoff = radius*sin(angle);   % from each reference position.

    hfrac = xoff - floor(xoff); % Fractional offset of xoff relative to integer location
    vfrac = yoff - floor(yoff); % Fractional offset of yoff relative to integer location

    orient = fix(orient)+1;     % Orientations start at 0 degrees but arrays start
                                % with index 1.

    % Now run through the image interpolating grey values on each side
    % of the centre pixel to be used for the non-maximal suppression.

    for row = (iradius+1):(rows - iradius)
      for col = (iradius+1):(cols - iradius) 

        or = orient(row,col);   % Index into precomputed arrays

        x = col + xoff(or);     % x, y location on one side of the point in question
        y = row - yoff(or);

        fx = floor(x);          % Get integer pixel locations that surround location x,y
        cx = ceil(x);
        fy = floor(y);
        cy = ceil(y);
        tl = inimage(fy,fx);    % Value at top left integer pixel location.
        tr = inimage(fy,cx);    % top right
        bl = inimage(cy,fx);    % bottom left
        br = inimage(cy,cx);    % bottom right

        upperavg = tl + hfrac(or) * (tr - tl);  % Now use bilinear interpolation to
        loweravg = bl + hfrac(or) * (br - bl);  % estimate value at x,y
        v1 = upperavg + vfrac(or) * (loweravg - upperavg);

      if inimage(row, col) > v1 % We need to check the value on the other side...

        x = col - xoff(or);     % x, y location on the `other side' of the point in question
        y = row + yoff(or);

        fx = floor(x);
        cx = ceil(x);
        fy = floor(y);
        cy = ceil(y);
        tl = inimage(fy,fx);    % Value at top left integer pixel location.
        tr = inimage(fy,cx);    % top right
        bl = inimage(cy,fx);    % bottom left
        br = inimage(cy,cx);    % bottom right
        upperavg = tl + hfrac(or) * (tr - tl);
        loweravg = bl + hfrac(or) * (br - bl);
        v2 = upperavg + vfrac(or) * (loweravg - upperavg);

        if inimage(row,col) > v2            % This is a local maximum.
          im(row, col) = inimage(row, col); % Record value in the output image.
        end

       end
      end
    end
end

function bw = hysthresh(im, T1, T2)

    if (T2 > T1 || T2 < 0 || T1 < 0)  % Check thesholds are sensible
      error('T1 must be >= T2 and both must be >= 0 ');
    end

    [rows, cols] = size(im);    % Precompute some values for speed and convenience.
    rc = rows*cols;
    rcmr = rc - rows;
    rp1 = rows+1;

    bw = im(:);                 % Make image into a column vector
    pix = find(bw > T1);        % Find indices of all pixels with value > T1
    npix = size(pix,1);         % Find the number of pixels with value > T1

    stack = zeros(rows*cols,1); % Create a stack array (that should never
                                % overflow!)

    stack(1:npix) = pix;        % Put all the edge points on the stack
    stp = npix;                 % set stack pointer
    for k = 1:npix
        bw(pix(k)) = -1;        % mark points as edges
    end


    % Precompute an array, O, of index offset values that correspond to the eight 
    % surrounding pixels of any point. Note that the image was transformed into
    % a column vector, so if we reshape the image back to a square the indices 
    % surrounding a pixel with index, n, will be:
    %              n-rows-1   n-1   n+rows-1
    %
    %               n-rows     n     n+rows
    %                     
    %              n-rows+1   n+1   n+rows+1

    O = [-1, 1, -rows-1, -rows, -rows+1, rows-1, rows, rows+1];

    while stp ~= 0            % While the stack is not empty
        v = stack(stp);         % Pop next index off the stack
        stp = stp - 1;

        if v > rp1 && v < rcmr   % Prevent us from generating illegal indices
                    % Now look at surrounding pixels to see if they
                                % should be pushed onto the stack to be
                                % processed as well.
           index = O+v;	    % Calculate indices of points around this pixel.	    
           for l = 1:8
           ind = index(l);
           if bw(ind) > T2   % if value > T2,
               stp = stp+1;  % push index onto the stack.
               stack(stp) = ind;
               bw(ind) = -1; % mark this as an edge point
           end
           end
        end
    end



    bw = (bw == -1);            % Finally zero out anything that was not an edge 
    bw = reshape(bw,rows,cols); % and reshape the image
end
