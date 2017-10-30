function [newChromosome1, newChromosome2] = Cross(chromosome1,chromosome2,minChromosomeLength,maxChromosomeLength)
  nInstructions1 = length(chromosome1)/4;
  nInstructions2 = length(chromosome2)/4;
  
  minInstructions = minChromosomeLength/4;
  maxInstructions = maxChromosomeLength/4;
  validCrossover = false;
  
  while ( validCrossover == false)
      chromosome1Cross(1:2) = 0;
      chromosome2Cross(1:2) = 0;
      while chromosome1Cross(1) == chromosome1Cross(2)
          chromosome1Cross(1) = 1 + fix(rand*(nInstructions1-1));
          chromosome1Cross(2) = 1 + fix(rand*(nInstructions1-1));
      end
      
      
      while chromosome2Cross(1) == chromosome2Cross(2)
          chromosome2Cross(1) = 1 + fix(rand*(nInstructions2-1));
          chromosome2Cross(2) = 1 + fix(rand*(nInstructions2-1));
      end
      
      chromosome1Cross = sort(chromosome1Cross);
      chromosome2Cross = sort(chromosome2Cross);
      
      chromosome1Loss = abs(chromosome1Cross(1)-chromosome1Cross(2));
      chromosome2Loss = abs(chromosome2Cross(1)-chromosome2Cross(2));
      
      newChromosome1Length = nInstructions1 - chromosome1Loss + chromosome2Loss;
      newChromosome2Length = nInstructions2 - chromosome2Loss + chromosome1Loss;
      
      %Booleans to determine if the crossover will be valid
      boolChromosome1(1) = newChromosome1Length >= minInstructions;
      boolChromosome1(2) = newChromosome1Length <= maxInstructions;
      
      boolChromosome2(1) = newChromosome2Length >= minInstructions;
      boolChromosome2(2) = newChromosome2Length <= maxInstructions;
      
      bool1 = boolChromosome1(1) == true && boolChromosome1(2) == true;
      bool2 = boolChromosome2(1) == true && boolChromosome2(2) == true;
      
      if (bool1 ==true && bool2 == true)
          
          
          chromosomeCrossPart1 =   chromosome1(4*chromosome1Cross(1)+1:4*chromosome1Cross(2));
          chromosomeCrossPart2 =   chromosome2(4*chromosome2Cross(1)+1:4*chromosome2Cross(2));
          
          newChromosome1 = [chromosome1(1:4*chromosome1Cross(1))   chromosomeCrossPart2 chromosome1(4*chromosome1Cross(2)+1:end)];
          newChromosome2 = [chromosome2(1:4*chromosome2Cross(1))   chromosomeCrossPart1 chromosome2(4*chromosome2Cross(2)+1:end)];
          
          
          validCrossover = true;
          return 
      end
      
  end
end

