function pathLength = GetPathLength(path,cityLocation)
  nCities = length(path);
  pathLength = 0;

  for i = 1:nCities-1
      firstCityLocation = cityLocation(path(i),:);
      secondCityLocation = cityLocation(path(i+1),:);
      
      segmentLength = sqrt((firstCityLocation(1,1)-secondCityLocation(1,1))^2 + ...
          (firstCityLocation(1,2)-secondCityLocation(1,2))^2); 
      pathLength = pathLength + segmentLength;
  end
  firstCityLocation = cityLocation(path(1),:);
  secondCityLocation = cityLocation(path(nCities),:);
  returnSegmentLength = sqrt((firstCityLocation(1,1)-secondCityLocation(1,1))^2 + ...
      (firstCityLocation(1,2)-secondCityLocation(1,2))^2);
  pathLength = pathLength + returnSegmentLength;
      
  
  
end

