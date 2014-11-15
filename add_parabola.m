function img=add_parabola(imagen, center, radio)
    size2=size(imagen);
    img=restrict_area(imagen, center, radio);
    %count=count_pixels(imagen);
    phis=zeros(numel(imagen),1);
    ps=zeros(numel(imagen),1);
    k=1;
    for i=1:size2(1)
        for j=1:size2(2)
            if imagen(i,j)==0
                continue
            end
            [phi,p]=houghparabola(img,i,j,10,130);
            phis(k)=phi(1);
            ps(k)=p(1);
            k=k+1;
        end
    end
    plotParabola(imagen,ps,center);
end
function plotParabola(imagen,ps,center)
    t=0:0.1:100;
    x=2*ps*t+center(1);
    y=ps*(t.^2)+center(2);
    figure, imshow(imagen), hold on
    for k = 1:length(ps)
       plot(x,y,'LineWidth',2,'Color','green');
    end
end
function img=restrict_area(imagen,center,radio)
    img=filter_edges(imagen);
end