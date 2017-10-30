function ContourPlot()


a = 0.01;
x = linspace(-5,5);
y = linspace(-5,5);
[X,Y] = meshgrid(x,y);
Z =  ((X.^2+Y-11).^2 +(X+Y.^2-7).^2);
% z = Z;
z = log(a+Z);

contour(X,Y,z,40);
% colorbar;
end