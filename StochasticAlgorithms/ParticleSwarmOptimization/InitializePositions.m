function initialPositions = InitializePositions(numberOfParticles,dimensionality, rangeMin, rangeMax)
  
  initialPositions = zeros(numberOfParticles,dimensionality);
  
  for j = 1:dimensionality
      for i = 1:numberOfParticles
          
          initialPositions(i,j) = rangeMin + rand*(rangeMax - rangeMin);
      end
  end
      
      
end

