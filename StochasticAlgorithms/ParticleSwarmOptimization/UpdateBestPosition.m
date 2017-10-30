function [bestParticlePositions, xBestPerformance] = UpdateBestPosition(positions,evaluatedParticles,bestParticlePositions, xBestPerformance)
  nParticles = length(evaluatedParticles);
  xEvaluatedBestPosition = EvaluateParticles(bestParticlePositions);
  xEvaluatedBestPerformance = EvaluateParticles(xBestPerformance);
  
  for i = 1:nParticles
      if evaluatedParticles(i) < xEvaluatedBestPosition(i)
          bestParticlePositions(i,:) = positions(i,:);
      end
      if evaluatedParticles(i) < xEvaluatedBestPerformance
          xBestPerformance = positions(i,:);
      end
  end
          



end

