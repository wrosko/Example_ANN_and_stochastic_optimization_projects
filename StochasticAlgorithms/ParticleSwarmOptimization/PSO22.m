clear all; clc;


numberOfParticles = 20;
dimensionality = 2;
numberOfGenerations = 1000;
rangeMin = -5;
rangeMax = 5;
vMax = 10;
vMin = -vMax;
deltaT = 1;
alpha = 1;
inertiaWeight = 1.4;
inertiaWeightMin = 0.4;
beta = 0.99;
c1 = 2;
c2 = 2;

allMinima = zeros(4,2);
iAllMinima = 1;

for j = 1:25
    
    bestParticlePositions(1:numberOfParticles,1:2) = Inf;
    xBestPerformance(1,1:2) = Inf;
    
    positions = InitializePositions(numberOfParticles,dimensionality, rangeMin, rangeMax);
    velocities = InitializeVelocities(numberOfParticles,dimensionality, rangeMin, rangeMax, deltaT,alpha);
    
    
    for i = 1:numberOfGenerations
        
        evaluatedParticles  = EvaluateParticles(positions);
        [bestParticlePositions, xBestPerformance] = UpdateBestPosition(positions,evaluatedParticles,bestParticlePositions, xBestPerformance);
        
        updatedVelocities = UpdateVelocities(inertiaWeight, velocities, c1, c2, positions, bestParticlePositions, xBestPerformance, deltaT);
        
        velocities = RestrictVelocities(updatedVelocities,vMax,vMin);
        positions = positions + deltaT * velocities;
        
        if inertiaWeight > inertiaWeightMin
            inertiaWeight = inertiaWeight*beta;
        else
            inertiaWeight = inertiaWeightMin;
        end
        
    end
    xBestPerformance = round(xBestPerformance,6);
    if ~ismember(xBestPerformance,allMinima,'rows') 
        allMinima(iAllMinima,:) = xBestPerformance;
        functionValue(iAllMinima) = round((xBestPerformance(1,1)^2+xBestPerformance(1,2)-11)^2 ...
            +(xBestPerformance(1,1)+xBestPerformance(1,2)^2-7)^2,6);
        iAllMinima = iAllMinima +1;
        
    end
end


allResults(:,1:2) = allMinima;
allResults(:,3) = functionValue; 


ContourPlot
hold on

scatter(allMinima(:,1),allMinima(:,2),'red','filled')
legend('Contour','Minima locations')

disp(sprintf('x values     y values   function value '));
for i = 1:4
    disp(sprintf('%.6f      %.6f       %.6f',allResults(i,1),allResults(i,2),allResults(i,3)));
end


