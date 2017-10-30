clear all; clc; close all;
tic


cityLocations = LoadCityLocations;
nCities = length(cityLocations);

%%%Parameters
populationSize = 60;
mutationProbability = 0.025;
pTournament = 0.75;
tournamentSize = 3;
numberOfGenerations = 2500;
copiesOfBestIndividual = 2;
copiesPlusOne = copiesOfBestIndividual+1;
%%%


fitness = zeros(populationSize,1);

population = InitializePopulation(populationSize,nCities);
% population(1,:)=[48,36,32,29,30,25,27,35,38,49,50,43,24,21,11,10,15,9,1,5,4,2,6,12,18,31,34,39,41,44,46,47,45,42,37,33,26,23,22,19,16,17,14,3,7,8,13,20,28,40,48];

for iGeneration = 1:numberOfGenerations
    clf;
    disp(iGeneration);
    maximumFitness = 0;
    pathBest = zeros(1,nCities);
    bestIndividualIndex = 0;
    for i = 1:populationSize
        iChromosome = population(i,:);
        fitness(i) = EvaluateIndividual(iChromosome,cityLocations(:,:));
        
        if (fitness(i) > maximumFitness)
            maximumFitness = fitness(i);
            bestIndividualIndex = i;
            pathBest = iChromosome;
        end
    end
    
    tempPopulation = population;
    
    for i = copiesPlusOne:populationSize
        selectedIndividual = TournamentSelect(fitness,pTournament,tournamentSize,populationSize);
        tempPopulation(i,:) = population(selectedIndividual,:);
    end
    
    
    for i = copiesPlusOne:populationSize
        originalChromosome = tempPopulation(i,:);
        mutatedChromosome = Mutate(originalChromosome,mutationProbability);
        tempPopulation(i,:) = mutatedChromosome;
    end
    
    bestIndividual = population(bestIndividualIndex,:);
    tempPopulation = InsertBestIndividual(tempPopulation,bestIndividual,copiesOfBestIndividual);
    
    tspFigure = InitializeTspPlot(cityLocations,[0 20 0 20]);
    connection = InitializeConnections(cityLocations);
    PlotPath(connection,cityLocations,bestIndividual);
    population = tempPopulation;
    bestPath = EvaluateBestIndividual(bestIndividual,cityLocations);
    disp(bestPath);
end



disp('The best path length found was:'),disp(bestPath);
toc
