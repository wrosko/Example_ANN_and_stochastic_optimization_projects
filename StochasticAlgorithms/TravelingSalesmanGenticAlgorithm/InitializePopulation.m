function population = InitializePopulation( populationSize, nCities )
  population = zeros(populationSize, nCities+1);
  for i = 1:populationSize
      population(i,1:nCities) = randperm(nCities);
      population(i,nCities+1) = population(i,1);
  end 

end

