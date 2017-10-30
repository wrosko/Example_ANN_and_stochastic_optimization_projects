clear all; clc;

mu = [0,1,10,100,1000,1200];
T = 10e-6;
eta = 0.0001;

x0 = [1;2];

for i = 1:length(mu);
    [MU(i,1),x1Star(i,1),x2Star(i,1)] = GradientDescent(x0,mu(i),eta,T);
end

display(['Penalty Method Results'])
fprintf('\n')
display('mu value    x1Star    x2Star')
fprintf('\n')

fprintf('%8.0f %8.3f %8.3f\n', [MU,x1Star,x2Star]')