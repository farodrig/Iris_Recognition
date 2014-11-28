type = 2; %1: sin filtro; 2:Con Filtro Gaussiano
%Tratar de dejar centers y radios en el ambiente antes de correr
if ~exist('centers', 'var') || ~exist('radios', 'var')
    run('carga_centros.m')
end
cargar = false; %True cargar archivos codes_n1 y mask_n1. False: crear nuevamente máscaras y codigos.
if cargar
    codes = load('codes_n1.mat');
    codes = codes.codes;
    masks = load('mask_n1.mat');
    masks = masks.noise_mask;
else
    if ~exist('imgs', 'var')
        imgs = LoadFiles('DataSet');
    end
    masks = {};
    codes = {};
    for i = 1:numel(imgs)
        [rect] = makeRectangle(imgs{i}, centers(i,:), radios(i,:), 360, 30, type);
        [L1, L2] = getEyelidsLines(imgs{i}, centers(i,:), radios(i,:));        
        [noise] = makeMask(imgs{i}, centers(i,:), radios(i,:), L1, L2, type); %Solo con las rectas de los párpados.
        [iriscode, mask]=createCode(rect,noise);
        masks{i} = mask;
        codes{i} = iriscode;
    end
end
[test_izq, train_izq, test_der, train_der]=createTrainTest(codes,masks);
[rocExpect, rocObtain, confExpect, confObtain] = testing(train_der,test_der, train_izq, test_izq);
plotroc(rocExpect, rocObtain);
C = confusionmat(confExpect, confObtain); %Matriz de Confusión
acierto = sum(diag(C))*100/(numel(test_der)+numel(test_izq)); %Notar que C siempre nos da una diagonal => 0%False Positive!!
