function evaluatedParticles = EvaluateParticles(positions)
  [nParticles,~] = size(positions);
  evaluatedParticles = zeros(1,nParticles);
  
  for i = 1:nParticles
      xPosition = positions(i,1);
      yPosition = positions(i,2);
      evaluatedParticles(i) = (xPosition^2 + yPosition - 11)^2 + (xPosition + yPosition^2 -7)^2;
  end

end

