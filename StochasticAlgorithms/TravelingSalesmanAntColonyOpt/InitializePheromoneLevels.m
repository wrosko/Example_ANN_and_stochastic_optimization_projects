function pheromoneLevel = InitializePheromoneLevels(numberOfCities, tau0)
  pheromoneLevel(1:numberOfCities,1:numberOfCities) = tau0;
  for i = 1:numberOfCities
      pheromoneLevel(i,i) = 0;
  end
end

