function initialVelocities = InitializeVelocities(numberOfParticles,dimensionality, rangeMin, rangeMax, deltaT,alpha);
    
  initialVelocities = zeros(numberOfParticles,dimensionality);
  
  for j = 1:dimensionality
      for i = 1:numberOfParticles
          
          initialVelocities(i,j) = (alpha/deltaT) * (-((rangeMax-rangeMin)/2) + rand*(rangeMax-rangeMin));
      end
  end

end

