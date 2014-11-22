function iriscode=createCode(img)
%Create the iris code for matching, img must be a rectangular iris image
%usamos solo un filtro de gabor.
    nscale=1; %numero de filtros
    minWaveLength=18;
    mult=1; % not applicable if using nscales = 1
    sigmaOnf=0.5;
    %gaborArray=gaborFilterBank(1,1,39,39);
    [gaborResult vector]=gaborconvolve(img, nscale, minWaveLength, mult, ...
    sigmaOnf);
    E1 = gaborResult{1,1};
    k=1;
    length = size(img,2)*2*nscale;
    iriscode = zeros(size(img,1), length);
    length2 = size(img,2);
    h = 1:size(img,1);
    %Phase quantisation
    H1 = real(E1) > 0;
    H2 = imag(E1) > 0;
    for i=0:(length2-1)             
        ja = double(2*nscale*(i));
        %construct the biometric template
        iriscode(h,ja+(2*k)-1) = H1(h, i+1);
        iriscode(h,ja+(2*k)) = H2(h,i+1);
    end
end 