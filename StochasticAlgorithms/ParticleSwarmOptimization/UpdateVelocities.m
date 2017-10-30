function velocities = UpdateVelocities(inertiaWeight, velocities, c1, c2, positions, bestParticlePositions, xBestPerformance, deltaT)
  [nParticles, dimensionality] = size(positions);
  
  
  for i = 1:nParticles
      q = rand;
      r = 1-q;
      
      for j = 1:dimensionality
          
          
          wVijTerm = inertiaWeight * velocities(i,j);
          c1qTerm = c1 * q * ((bestParticlePositions(i,j) - positions(i,j))/deltaT);
          c2rTerm = c2 * r * ((xBestPerformance(j) - positions(i,j))/deltaT);
          
          velocities(i,j) = wVijTerm + c1qTerm + c2rTerm;       
      end
  end
  
      
          

end

