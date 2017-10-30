function fitness = EvaluateIndividual(yK, functionData)
  nPoints = length(functionData);
  
  sumTerm = 0;
  for i = 1:nPoints
      sumTerm = sumTerm + (yK(i)-functionData(i,2))^2;
  end
  error = sqrt((1/nPoints)*sumTerm);
  fitness = 1/error;
end

