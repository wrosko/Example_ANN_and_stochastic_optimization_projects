clear all;clc;
clf;close all;

functionData = LoadFunctionData();

%PARAMETERS
populationSize = 100;
numberOfGenerations = 1000;
copiesOfBestIndividual = 10;
copiesOfMutatedBestIndividual = 7;
copiesOfRegularBestIndividual = copiesOfBestIndividual-copiesOfMutatedBestIndividual;
pTournament = 0.75;
tournamentSize = 3;
crossoverProbability = 0.8;
mutationProbability = 0.025;
maxChromosomeLength = 100;
minChromosomeLength = 20;
maxFit = 1.4866e6;
plotNumber = 100;  %Plots the current best chromosome every plotNumber generations

%REGISTERS
cRegister = [1];
rRegister = [1 0 0];   
operators = [1 2 3 4]; % +,-,*,/
cMax = 1e20;

operandsRange = length(cRegister)+length(rRegister);
operatorRange = 4;
destinationRegisterRange = length(rRegister);




xK= functionData(:,1);

population = InitializePopulation(populationSize,minChromosomeLength,maxChromosomeLength,operandsRange,operatorRange,destinationRegisterRange);

plot(functionData(:,1),functionData(:,2), 'b');
hold on;

maximumFitness = 0;
iGeneration = 1;

%%%%%%%%
% while (maximumFitness < maxFit)       %Uncomment this line and line 105, and comment line 44 if a while loop is wanted.
for iGeneration = 1:100%numberOfGenerations
%%%%%%%%    

    bestIndividualIndex = 0;
    fitness(1:populationSize) = 0;
    
    for i = 1:populationSize
        chromosome = population(i).Chromosome;
        yK{i} = DecodeChromosome(chromosome,xK,cRegister,rRegister,cMax);
        
        fitness(i) = EvaluateIndividual(yK{i}, functionData);
        
        if (fitness(i) >= maximumFitness)
            maximumFitness = fitness(i);
            bestIndividualIndex = i;
            bestInd{iGeneration} = population(bestIndividualIndex).Chromosome;  %These two lines were used to check the best individuals
            bestGenFitness(i,1)= fitness(i);                                    %after a run or a canceled run since they are stored in 
        end                                                                     %memory here.
    end
       
    tempPopulation = population;
    
    for i = 1:2:populationSize
        i1 = TournamentSelect(fitness,pTournament,tournamentSize);
        i2 = TournamentSelect(fitness,pTournament,tournamentSize);
        chromosome1 = population(i1).Chromosome;
        chromosome2 = population(i2).Chromosome;
        
        r = rand;
        if (r < crossoverProbability)
            [tempPopulation(i).Chromosome, tempPopulation(i+1).Chromosome]= Cross(chromosome1,chromosome2,minChromosomeLength,maxChromosomeLength);
        else
            tempPopulation(i).Chromosome = chromosome1;
            tempPopulation(i+1).Chromosome = chromosome2;
        end
    end
    
    bestIndividual = population(bestIndividualIndex).Chromosome;
    tempPopulation = InsertBestIndividual(tempPopulation, bestIndividual,copiesOfBestIndividual);
    
    for i = copiesOfRegularBestIndividual+1:populationSize
        originalChromosome = tempPopulation(i).Chromosome;
        mutatedChromosome = Mutate(originalChromosome,mutationProbability,operators,rRegister,cRegister);
        tempPopulation(i).Chromosome = mutatedChromosome;
    end

    population = tempPopulation;
    error = 1/maximumFitness;
    DISP = sprintf('The generation is %d, the fitness is %.6f, and the error is %.6f',iGeneration,maximumFitness,error);
    disp(DISP)
    
    
    if rem(iGeneration,plotNumber) == 0
        scatter(functionData(:,1),yK{bestIndividualIndex},'o');
        drawnow
    end
    
    
    if rem(iGeneration,500) == 0
        clf;
        plot(functionData(:,1),functionData(:,2), 'b');
        hold on;
        scatter(functionData(:,1),yK{bestIndividualIndex},'o');
        drawnow
    end
%     iGeneration = iGeneration +1;
end
equation = char(BestChromosomeEquationGenerator(bestIndividual,cRegister,cMax));
disp(sprintf('The Equation is: %s',equation));
