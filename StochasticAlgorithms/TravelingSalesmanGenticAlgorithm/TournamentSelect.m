function selectedIndividual = TournamentSelect(fitness,pTournament,tournamentSize,populationSize)
  fitnessValues(1:tournamentSize) = 0;
  
  for i = 1:tournamentSize
      tempIndexNumber = 1 + fix(rand*populationSize);
      fitnessValues(i) = fitness(tempIndexNumber);
  end
  
  tempFitness = fitnessValues;
  
  selectedBool = false;
  while(selectedBool == false);
      r = rand;
      [~, index] = max(tempFitness);
      
      if (r < pTournament)
          selectedIndividual = index;
          selectedBool = true;
      else
          tempFitness(index) = 0;
      end
  end
     
end

