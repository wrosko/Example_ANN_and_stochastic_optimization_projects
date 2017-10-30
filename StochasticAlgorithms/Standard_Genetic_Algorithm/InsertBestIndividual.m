function modifiedPopulation = InsertBestIndividual( population, bestIndividual,nCopies )
  modifiedPopulation = population;
  for i = 1:nCopies
      modifiedPopulation(i,:) = bestIndividual(1,:);
  end

end

