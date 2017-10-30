function modifiedPopulation = InsertBestIndividual( population, bestIndividual,nCopies )
  modifiedPopulation = population;
  for i = 1:nCopies
      modifiedPopulation(i).Chromosome = bestIndividual;
  end

end
