function mask=remove_noise(imgRec)
%quita el ruido de una imagen, recibe una imagen rectangular
%     mask=zeros(size(imgRec));
%     noise=calculate_var(imgRec);
%     coords = find(isnan(noise));
%     mask(coords) = 1;
    %intensidad=calculate_intensity(imgRec);
    mask=calculate_var2(imgRec);
end
function mask=calculate_var(imgRec)
    reference1=imgRec(5:10,10:75);
    reference2=imgRec(5:10,170:175);
    reference3=imgRec(5:10,340:345);
    mask=zeros(size(imgRec));
    replace=NaN(5);
    variance_ref1=var(double(reference1(:)));
    variance_ref2=var(double(reference2(:)));
    variance_ref3=var(double(reference3(:)));
    total_var=[variance_ref1 variance_ref2 variance_ref3];
    variance_ref=mean(total_var);
    for inicioY=26:-4:18
        finX=5;
        for inicioX=1:4:size(imgRec,2)-4
            if (inicioX+4)>=360
                finX=360;
            end
            inicial=imgRec(inicioY:(inicioY+4),inicioX:(finX));
            variance=var(double(inicial(:)));
            if abs(variance-variance_ref)>=115
                mask(inicioY:(inicioY+4),inicioX:finX)=replace;
            end
            finX=finX+4;
        end
    end
end
function intensity=calculate_intensity(imgRec)
    intensity=zeros(size(imgRec)/5);
    for inicioY=size(imgRec,1)-4:-4:1
        finX=5;
        for inicioX=1:4:size(imgRec,2)
            if (inicioX+4)>=360
                finX=360;
            end
            local=imgRec(inicioY:(inicioY+4),inicioX:(finX));
            local_intensity=mean2(local);
            intensity(ceil(inicioY/5),ceil(inicioX/5))=local_intensity;
            finX=finX+4;
        end
    end
end
function img=calculate_var2(imgRec)
    reference1=imgRec(5:10,10:75);
    reference2=imgRec(5:10,170:175);
    reference3=imgRec(5:10,340:345);
    replace=NaN(5);
    imgAux=imgRec;
    variance_ref1=var(double(reference1(:)));
    variance_ref2=var(double(reference2(:)));
    variance_ref3=var(double(reference3(:)));
    total_var=[variance_ref1 variance_ref2 variance_ref3];
    variance_ref=mean(total_var);
    for inicioY=26:-4:18
        finX=5;
        for inicioX=1:4:size(imgRec,2)-4
            if (inicioX+4)>=360
                finX=360;
            end
            inicial=imgRec(inicioY:(inicioY+4),inicioX:(finX));
            variance=var(double(inicial(:)));
            if abs(variance-variance_ref)>=105
                imgAux(inicioY:(inicioY+4),inicioX:finX)=replace;
            end
            finX=finX+4;
        end
    end
    img=completeImg(imgAux,imgRec);
end
function img=completeImg(img,imgRec)
    nnan=0;
    for inicioY=size(img,1)-4:-4:5
        for inicioX=1:4:(size(img,2)-4)
            if img(inicioY,inicioX)==0
                nnan=nnan+1;
                changeX=inicioX;
                changeY=inicioY;
            else
                if (nnan<=3 && nnan>0)
                    img(changeY:changeY+4,changeX-4:changeX)=imgRec(changeY:changeY+4,changeX-4:changeX);
                    nnan=0;
                end
            end
        end
        nnan=0;
    end
end