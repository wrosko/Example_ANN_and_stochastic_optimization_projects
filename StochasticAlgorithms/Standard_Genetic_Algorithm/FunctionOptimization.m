clear all; clc;

populationSize = 60;
numberOfGenes = 100;
crossoverProbability = 0.8;
mutationProbability = 0.025;
pTournament = 0.75;
tournamentSize = 3;
variableRange = 5.0;
numberOfGenerations = 100;
numberOfVariables = 2;
copiesOfBestIndividual = 1;



fitness = zeros(populationSize,1);


population = InitializePopulation(populationSize,numberOfGenes);

for iGeneration = 1:numberOfGenerations
    
    maximumFitness = 0.0;
    xBest = zeros(1,2);
    bestIndividualIndex = 0;
    for i = 1:populationSize
        chromosome = population(i,:);
        x = DecodeChromosome(chromosome,numberOfVariables,variableRange);
        
        fitness(i) = EvaluateIndividual(x);
        if (fitness(i) >  maximumFitness)
            maximumFitness = fitness(i);
            bestIndividualIndex = i;
            xBest = x;
        end
    end
    xBestVal(iGeneration,:) = xBest;
    
    tempPopulation =  population;
    
    
    for i = 1:2:populationSize
        i1 = TournamentSelect(fitness,pTournament,tournamentSize);
        i2 = TournamentSelect(fitness,pTournament,tournamentSize);
        chromosome1 = population(i1,:);
        chromosome2 = population(i2,:);
        
        r = rand;
        if (r < crossoverProbability)
            newChromosomePair = Cross(chromosome1,chromosome2);
            tempPopulation(i,:) = newChromosomePair(1,:);
            tempPopulation(i+1,:) = newChromosomePair(2,:);
        else
            tempPopulation(i,:) = chromosome1;
            tempPopulation(i,:) = chromosome2;
        end
    end
    
    for i = 1:populationSize
        originalChromosome = tempPopulation(i,:);
        mutatedChromosome = Mutate(originalChromosome,mutationProbability);
        tempPopulation(i,:) = mutatedChromosome;
    end
    
    bestIndividual = population(bestIndividualIndex,:);
    tempPopulation = InsertBestIndividual(tempPopulation,bestIndividual, ...
        copiesOfBestIndividual);
    population = tempPopulation;
end

%Evaluate G(x1,x2) value
gPartOne = (xBest(1,1)+xBest(1,2)+1)^2;
gPartTwo = (19 - 14*xBest(1,1) + 3*xBest(1,1)^2 - 14*xBest(1,2) +6*xBest(1,1)*xBest(1,2)+ ...
    3*xBest(1,2)^2);
gPartThree = (2*xBest(1,1)-3*xBest(1,2))^2;
gPartFour = (18 - 32*xBest(1,1) + 12*xBest(1,1)^2 + 48*xBest(1,2)- 36*xBest(1,1)*xBest(1,2)+ ...
    27*xBest(1,2)^2);
g = (1+gPartOne*gPartTwo)*(30+gPartThree*gPartFour);

display(['Evolutionary Algorithm Results'])
fprintf('\n')
display('g(x1,x2) min value    x1Star    x2Star')
fprintf('\n')

fprintf('%18.3f %9.3f %9.3f\n', [g,xBest(1,1),xBest(1,2)]')

