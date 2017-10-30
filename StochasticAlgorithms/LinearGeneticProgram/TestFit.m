clear all; clc;clf;

functionData = LoadFunctionData;
cRegister = [1];
cMax = 1e20;

bestChromosome = [3,2,3,2,3,3,2,1,1,2,3,1,3,3,2,1,3,2,4,2,3,2,4,4,3,2,1,1,4,2,1,4,2,2,4,3,3,2,2,4,2,2,4,4,3,2,3,1,2,3,2,3,4,2,2,1,3,2,4,3,1,2,4,4,3,2,4,1,3,2,2,1,4,2,3,1,3,1,3,1,4,2,1,1,1,3,3,2,1,2,3,1,4,1,3,2,1,3,1,4];
equation = char(BestChromosomeEquationGenerator(bestChromosome,cRegister,cMax));

equationValue(1:length(functionData)) = 0;
for i = 1:length(functionData)
    x = functionData(i,1);
    equationValue(i) = (x^3 - x^2 + 1)/(x^4 - x^2 + 1);
end

plot(functionData(:,1),functionData(:,2),'blue','LineWidth',2);
hold on
scatter(functionData(:,1),equationValue(:),'red');
legend('Function Data','Best Chromosome Equation')
xlabel('X')
ylabel('Y')
title('Function Data and Results from Best Chromosome Equation')

error = 1/EvaluateIndividual(equationValue,functionData);
DISP1 = sprintf('The Equation is: %s',equation);
DISP = sprintf('The error is %.6f',error);
disp(DISP1)
disp(DISP);