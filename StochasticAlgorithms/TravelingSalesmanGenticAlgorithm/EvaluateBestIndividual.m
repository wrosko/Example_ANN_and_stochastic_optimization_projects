function pathLength = EvaluateBestIndividual( individualPath, cityLocations)
  nCities = length(individualPath);
  pathLength = 0;
  
  for i = 1:nCities-1
      firstCityIndex = individualPath(i);
      secondCityIndex = individualPath(i+1);
      firstPoint = cityLocations(firstCityIndex,:);
      secondPoint = cityLocations(secondCityIndex,:);
      
      distance = sqrt((firstPoint(1,1)-secondPoint(1,1))^2 +(firstPoint(1,2)...
          -secondPoint(1,2))^2);
      pathLength = pathLength + distance;
  end
  
end

