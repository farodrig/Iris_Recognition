[phi,p]=houghparabola(canny_img,208,161,215,240);
[phi2,p2]=houghparabola(canny_img,128,81,50,80);
t=-5:0.1:150;
t2=0:0.1:50;
x1=2*p2(2)*t+128;
x2=2*p(1)*t+208;
y1=p2(2)*(t.^2)+81;
y2=p(1)*(t.^2)+161;
figure, imshow(filtrada,[]), hold on
plot(x1,y1,'LineWidth',2,'Color','green')
plot(x2,y2,'LineWidth',2,'Color','red')