function iSelected = TournamentSelect( fitness, pTournament, tournamentSize)
  
  populationSize = length(fitness);
  fitnessValues(1:tournamentSize) = 0;

  for i = 1:tournamentSize
      tempIndexNumber = 1 + fix(rand*populationSize);
      fitnessValues(i) = fitness(tempIndexNumber);
  end

%   temporaryIndices
  tempFitness = fitnessValues;
  
  selectedBool = false;
  while (selectedBool == false)
      r = rand;
      [~, index] = max(tempFitness);
      
      if (r < pTournament)
          iSelected = index;
          selectedBool = true;
      else
          tempFitness(index) = 0;
      end
  end
  
end

