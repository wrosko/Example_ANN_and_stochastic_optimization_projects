function path = GeneratePath(pheromoneLevel, visibility, alpha, beta)
  nCities = length(pheromoneLevel);
  randomStartNode = 1 + fix(rand*nCities);
  tabuList(1) = randomStartNode;
  
  for i = 2:nCities
      nextNode = GetNode(tabuList,pheromoneLevel,visibility,alpha,beta);
      tabuList(i) = nextNode;
  end
  %tabuList(nCities+1) = tabuList(1);
  path = tabuList;
      
      
end
  
