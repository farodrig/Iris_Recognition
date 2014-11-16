function iriscode=createCode(img)
%Create the iris code for matching, img must be a rectangular iris image
%usamos solo un filtro de gabor.
    nscales=1; %numero de filtros
    gaborArray=gaborFilterBank(1,1,39,39);
    [gaborResult vector]=gaborFeatures(img,gaborArray,5,5);
    E1 = gaborResult{1,1};
    k=1;
    length = size(img,2)*2*nscales;
    iriscode = zeros(size(img,1), length);
    length2 = size(img,2);
    h = 1:size(img,1);
    %Phase quantisation
    H1 = real(E1) > 0;
    H2 = imag(E1) > 0;
    for i=0:(length2-1)             
        ja = double(2*nscales*(i));
        %construct the biometric template
        iriscode(h,ja+(2*k)-1) = H1(h, i+1);
        iriscode(h,ja+(2*k)) = H2(h,i+1);
    end
end 