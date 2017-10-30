function restrictedVelocities = RestrictVelocities(updatedVelocities,vMax,vMin)
  [nParticles,dimensionality] = size(updatedVelocities);
  restrictedVelocities = updatedVelocities;
  
  for i = 1:nParticles
      for j = 1:dimensionality
          
          if restrictedVelocities(i,j) > vMax
              restrictedVelocities(i,j) = vMax;
          end
          
          if restrictedVelocities(i,j) < vMin
              restrictedVelocities(i,j) = vMin;
          end
      end
  end

end

