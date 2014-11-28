function [rocExpect, rocObtain, confExpect, confObtain]=testing(train_der,test_der, train_izq, test_izq)
    confExpect=zeros(360,1);
    confObtain=zeros(360,1);
    k=1;
    for i=1:size(test_der,1)
        for j=1:size(test_der,2)
            confExpect(k,1)=i;
            k=k+1;
        end
    end
     for i=1:size(test_der,1)
        for j=1:size(test_der,2)
            confExpect(k,1)=i;
            k=k+1;
        end
    end
    k=1;
    for i=1:size(test_der,1)
        for j=1:size(test_der,2)
            dist1=getDistance(train_der{i}.code,train_der{i}.mask,test_der{i,j}.code,test_der{i,j}.mask);
            dist2=getDistance(train_izq{i}.code,train_izq{i}.mask,test_der{i,j}.code,test_der{i,j}.mask);
            if(dist1==1 || dist2==1)
                confObtain(k,1)=i;
            end
            k=k+1;
        end
    end
    for i=1:size(test_der,1)
        for j=1:size(test_der,2)
            dist1=getDistance(train_der{i}.code,train_der{i}.mask,test_izq{i,j}.code,test_izq{i,j}.mask);
            dist2=getDistance(train_izq{i}.code,train_izq{i}.mask,test_izq{i,j}.code,test_izq{i,j}.mask);
            if(dist1==1 || dist2==1)
                confObtain(k,1)=i;
            end
            k=k+1;
        end
    end
    for i = 1:numel(confObtain)
        if confObtain(i)==0
            confObtain(i)=NaN;
        end
    end
    rocExpect = [ones(1,360);zeros(1,360)];
    rocObtain = zeros(2,360);
    for i = 1:360
        if confObtain(i)==confExpect(i)
            rocObtain(1,i)=1;
        else
            rocObtain(2,i)=1;
        end
    end
end