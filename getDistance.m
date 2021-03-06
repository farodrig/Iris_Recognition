function dist=getDistance(code1, mask1,code2,mask2) 
    treshold=0.4;
    distancia=hamming2(code1,mask1,code2,mask2);
    if distancia<=treshold
        dist=1;
    else
        dist=0;
    end
end
function distancia=hamming(code1, code2)
    difference=zeros(size(code1,1),size(code1,2));
    for i=1 : size(code1,1)
        for k= 1 : size(code1,2)
            if(code1(i,k)~=code2(i,k))
                difference(i,k)=1;
            end
        end
    end
    distancia=sum(sum(difference))/numel(code1);
end

function distancia=hamming2(code1, mask1, code2, mask2)
    scales =1;
    distancia = intmax;
    for shifts=-8:8
        shiftCode1 = shiftbits(code1, shifts,scales);
        shiftMask1 = shiftbits(mask1, shifts,scales);
        mask = shiftMask1 | mask2;
        noMaskBits = sum(sum(mask == 1)); %Cantidad de bits de la m�scara.
        totalbits = (size(shiftCode1,1)*size(shiftCode1,2)) - noMaskBits;
        C = xor(shiftCode1,code2);
        C = C & ~mask;
        bitsdiff = sum(sum(C==1));
        if totalbits == 0
            distancia = intmax;
        else
            hd1 = bitsdiff / totalbits;
            if  hd1 < distancia
                distancia = hd1;
            end
        end
    end
end

function codenew = shiftbits(code, noshifts,scale)
    codenew = zeros(size(code));
    width = size(code,2);
    s = round(2*scale*abs(noshifts));
    p = round(width-s);
    if noshifts == 0
        codenew = code;
    elseif noshifts < 0
        x=1:p;
        codenew(:,x) = code(:,s+x);
        x=(p + 1):width;
        codenew(:,x) = code(:,x-p);
    else
        x=(s+1):width;
        codenew(:,x) = code(:,x-s);
        x=1:s;
        codenew(:,x) = code(:,p+x);
    end
end