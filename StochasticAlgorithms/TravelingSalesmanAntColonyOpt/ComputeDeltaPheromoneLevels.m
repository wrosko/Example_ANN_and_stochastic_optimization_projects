function deltaPheromoneLevel = ComputeDeltaPheromoneLevels(pathCollection,pathLengthCollection);
  nAnts = length(pathLengthCollection);   
  nCities = length(pathCollection);
  antDeltaPheromone = zeros(nCities,nCities,nAnts);
  
  for k = 1:nAnts
      currentAntPath = pathCollection(k,:);
      currentAntPathLength = pathLengthCollection(k);
      
      for i = 1:nCities-1
          iCity =  currentAntPath(i);
          jCity = currentAntPath(i+1);
          invPathLength = 1/currentAntPathLength;
          
          antDeltaPheromone(iCity,jCity,k) = invPathLength;
          antDeltaPheromone(jCity,iCity,k) = invPathLength;
      end
      firstCity = currentAntPath(1);
      lastCity = currentAntPath(nCities);
      invPathLength = 1/currentAntPathLength;
      antDeltaPheromone(firstCity,lastCity,k) = invPathLength;
      antDeltaPheromone(lastCity,firstCity,k) = invPathLength;
      
      
  end
  
  deltaPheromoneLevel = sum(antDeltaPheromone,3);
  
end

