clear; clc;

cityLocation = LoadCityLocations();

nearestNeighborPathLength = 0;
nCities = length(cityLocation);
cityIndices = [1:nCities];
randCity = 1 + fix(rand*nCities);

setS(1) = cityIndices(randCity);

currentLocation = cityLocation(randCity,:);

j = 1;

while (j < nCities)
    inverseBestSegment = 0;
    for i = 1:nCities
        
        z = cityIndices(i);
        if not(ismember(cityIndices(i),setS))
            
            
            testCity = cityIndices(i);
            testLocation = cityLocation(i,:);
            pathSegment = sqrt((  testLocation(1,1)-currentLocation(1,1))^2 + (  testLocation(1,2)-currentLocation(1,2))^2);
            inverseSegment = 1/pathSegment;
            
            if (inverseSegment > inverseBestSegment)
                tempBestSegment = pathSegment;
                inverseBestSegment = inverseSegment;
                tempNearestNeighbor = testCity;
            end
            
        end
        
        
    end
    
    setS(j+1) = tempNearestNeighbor;
    nearestNeighborPathLength = nearestNeighborPathLength + tempBestSegment;
    j = j + 1;
    currentCity = cityIndices(tempNearestNeighbor);
    currentLocation = cityLocation(currentCity,:);
    
    
end

firstCity = cityIndices(1);
lastCity = cityIndices(nCities);

firstLocation = cityLocation(firstCity,:);
lastLocation = cityLocation(lastCity,:);
pathSegment = sqrt((  firstLocation(1,1)-lastLocation(1,1))^2 + (  firstLocation(1,2)-lastLocation(1,2))^2);
nearestNeighborPathLength = nearestNeighborPathLength + pathSegment;

DISP = sprintf('The Nearest Neighbor Path Length starting at city %d is %f',randCity,nearestNeighborPathLength);
disp(DISP)
