function nextNode = GetNode(tabuList,pheromoneLevel, visibility, alpha, beta)
  tauTimesEta = pheromoneLevel.^alpha .* visibility.^beta;
  nCities = length(pheromoneLevel);
  jCity = tabuList(length(tabuList));
  
  sumTerm = 0;
  for l = 1:nCities
      if not(ismember(l,tabuList))
          tempSumTerm = tauTimesEta(l,jCity);
          sumTerm = sumTerm + tempSumTerm;
          
      end
  end
  
  totalProbability = 0;
  probability(1:nCities) = 0;
  for i = 1:nCities
      if not(ismember(i,tabuList))
          numerator = tauTimesEta(i,jCity);
          tempProbability = numerator/sumTerm;
          totalProbability = totalProbability + tempProbability;
          probability(i) = totalProbability;
      end
  end
  
  r = rand;
 
  while r == 0
      r = rand;
  end
 
  if (min(find(probability >= r & probability > 0)))
      nextNode = min(find(r <= probability  & probability > 0));
  else
      nextNode = max(find(probability > r));
  end
  
  
  
 
  
  

end

