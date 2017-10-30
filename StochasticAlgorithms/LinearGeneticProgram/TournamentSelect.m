function iSelected = TournamentSelect( fitness, pTournament, tournamentSize)
  
  populationSize = length(fitness);
  fitnessValues(1:tournamentSize) = 0;
  tempIndexNumber(1:tournamentSize) = 0;

  for i = 1:tournamentSize
      tempIndexNumber(i) = 1 + fix(rand*populationSize);
      fitnessValues(i) = fitness(tempIndexNumber(i));
  end

%   temporaryIndices
  tempFitness = fitnessValues;
  
  selectedBool = false;
  while (selectedBool == false)
      r = rand;
      numberOfZeros = 0;
      [~, index] = max(tempFitness);
      
      if (r < pTournament)
          iSelected = tempIndexNumber(index);
          selectedBool = true;
      else
          tempFitness(index) = 0;
          numberOfZeros = numberOfZeros +1;
      end
      if numberOfZeros == tournamentSize
          tempFitness = fitnessValues;
      end
  end
  
end
