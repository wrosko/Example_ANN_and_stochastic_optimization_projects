function population = InitializePopulation(populationSize,minChromosomeLength,maxChromosomeLength,operandsRange,operatorRange,destinationRegisterRange);

maxNumberInstructions = maxChromosomeLength/4;
minNumberInstructions = minChromosomeLength/4;

population = [];
for i = 1:populationSize
    
    numberOfInstructions = minNumberInstructions + fix(rand*(maxNumberInstructions-minNumberInstructions+1));
    tmpChromosome = ones(1,numberOfInstructions*4);
    
    iInstruction = 0;
    for j = 1:numberOfInstructions
        tmpChromosome(1,iInstruction*4+1) = 1 + fix(rand*operatorRange);
        tmpChromosome(1,iInstruction*4+2) = 1 + fix(rand*destinationRegisterRange);
        tmpChromosome(1,iInstruction*4+3) = 1 + fix(rand*operandsRange);
        tmpChromosome(1,iInstruction*4+4) = 1 + fix(rand*operandsRange);
        iInstruction = iInstruction+1;
    end
        
    tmpIndividual = struct('Chromosome',tmpChromosome);
    population = [population tmpIndividual];
end
end