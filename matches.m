function nmatches=matches(train,test)
    nmatches=zeros(1,size(train,1));
    matches=zeros(1,4);
    for i=1 : size(train,1)
        for k=1 : 4
            matches(k)=getDistance(train{i}.code,test{i,k}.code);
        end
        if sum(matches)>=3
            nmatches(i)=1;
        end
    end
end
