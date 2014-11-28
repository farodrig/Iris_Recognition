function total=matches(train,test)
    %nmatches=zeros(1,size(train,1));
    nmatches=zeros(180,1);
    %matches=zeros(1,4);
    j=1;
    for i=1 : size(train,1)
        for k=1 : 4
            nmatches(j)=getDistance(train{i}.code,train{i}.mask,test{i,k}.code,test{i,k}.mask);
            j=j+1;
        end
%         if sum(matches)>=2
%             nmatches(i)=1;
%         end
    end
    total=sum(nmatches);
end
