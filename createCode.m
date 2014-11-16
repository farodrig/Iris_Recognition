function iriscode=createCode(img)
%Create the iris code for matching, img must be a rectangular iris image
    gaborArray=gaborFilterBank(5,8,39,39);
    [gaborResult vector]=gaborFeatures(img,gaborArray,15,10);
ends 