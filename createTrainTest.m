function [test_izq, train_izq, test_der, train_der]=createTrainTest(codes)
    if ~exist('imgs', 'var')
        imgs = LoadFiles('DataSet');
    end
    [train_izq, test_izq]=createData(imgs,codes,5,10);
    [train_der, test_der]=createData(imgs,codes,10,10);
end
function [data_train,data_test]=createData(imgs,codes,fin,despl)
    k=1;
    data_train=cell(45,1);
    data_test=cell(45,4);
    while k<=45
        perm=getPermut(fin);
        dato=struct('img',imgs{perm(1)},'code',codes{perm(1)});%se accede haciendo dato.img o dato.code
        data_train{k}=dato;
        [dato2,dato3,dato4,dato5]=getDatos(perm,imgs,codes);
        data_test{k,1}=dato2;
        data_test{k,2}=dato3;
        data_test{k,3}=dato4;
        data_test{k,4}=dato5;
        k=k+1;
        fin=fin+despl;
    end
end
function [dato1,dato2,dato3,dato4]=getDatos(perm,imgs,codes)
    dato1=struct('img',imgs{perm(2)},'code',codes{perm(2)});
    dato2=struct('img',imgs{perm(3)},'code',codes{perm(3)});
    dato3=struct('img',imgs{perm(4)},'code',codes{perm(4)});
    dato4=struct('img',imgs{perm(5)},'code',codes{perm(5)});
end

function perm=getPermut(fin)
    perm=zeros(1,5);
    todas=randperm(fin);
    k=1;
    for i=1 : size(todas,2)
        if todas(i)<=(fin-5)
            continue
        end
        perm(k)=todas(i);
        k=k+1;
    end
end