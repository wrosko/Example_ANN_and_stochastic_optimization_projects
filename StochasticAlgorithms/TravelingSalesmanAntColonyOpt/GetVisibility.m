function visibility = GetVisibility(cityLocation)
  nCities = length(cityLocation);
  visibility = zeros(nCities);
  
  for i = 1:nCities
      iCity = cityLocation(i,:);
      for j = 1:nCities
          jCity = cityLocation(j,:);
          if not(i == j)
              euclideanDistance = sqrt((iCity(1,1)-jCity(1,1))^2 + (iCity(1,2)-jCity(1,2))^2);
              visibility(i,j) = 1/euclideanDistance;
          end
      end
  end


end

