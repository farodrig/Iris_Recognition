function distancia=getDistance(code1, code2)
    treshold=0.33;
    distancia=hamming(code1,code2);
    if treshold<0.33
        distancia=1;
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