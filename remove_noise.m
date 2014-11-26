function img=remove_noise(imgRec)
%quita el ruido de una imagen, recibe una imagen rectangular
    %ajuste=imadjust(imgRec);
    img=calculate_var(imgRec);
end
function img=calculate_var(imgRec)
    reference1=imgRec(5:10,10:75);
    reference2=imgRec(5:10,170:175);
    reference3=imgRec(5:10,340:345);
    %grilla=cell(5,72);
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
            if abs(variance-variance_ref)>=115
                imgAux(inicioY:(inicioY+4),inicioX:finX)=replace;
            end
            finX=finX+4;
            %grilla(floor(inicioY/4)+1,floor(inicioX/4)+1)=inicial;
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