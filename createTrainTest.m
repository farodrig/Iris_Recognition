function [test_izq, train_izq, test_der, train_der]=createTrainTest()
    if ~exist('imgs', 'var')
        imgs = LoadFiles('DataSet');
    end
    if ~exist('codes', 'var')
        run('carga_codes.m')
    end
    [train_izq, test_izq]=createData(imgs,codes,5,10);
    [train_der, test_der]=createData(imgs,codes,10,10);
end
function [data_train,data_test]=createData(imgs,codes,fin,despl)
    k=1;
    j=1;
    data_train=cell(45,1);
    data_test=cell(180,1);
    while k<=45 && j<=180
        perm=getPermut(fin);
        dato=struct('img',imgs{perm(1)},'code',codes{perm(1)});%se accede haciendo dato.img o dato.code
        data_train{k}=dato;
        [dato2,dato3,dato4,dato5]=getDatos(perm,igs,codes);
        data_test{j}=dato2;
        data_test{j+1}=dato3;
        data_test{j+2}=dato4;
        data_test{j+3}=dato5;
        k=k+1;
        j=j+4;
        fin=fin+despl;
    end
end
function [dato1,dato2,dato3,dato4]=getDatos(perm,imgs,codes)
    dato1=struct('img',imgs{perm(1)},'code',codes{perm(1)});
    dato2=struct('img',imgs{perm(2)},'code',codes{perm(2)});
    dato3=struct('img',imgs{perm(3)},'code',codes{perm(3)});
    dato4=struct('img',imgs{perm(4)},'code',codes{perm(4)});
end

function perm=getPermut(fin)
    perm=zeros(1,5);
    todas=randperm(fin);
    k=0;
    for i=1 : size(todas,2)
        if todas(i)<=(fin-5)
            continue
        end
        perm(k)=todas(i);
        k=k+1;
    end
end