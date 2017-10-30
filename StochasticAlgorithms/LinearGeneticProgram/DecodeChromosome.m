function yK= DecodeChromosome(chromosome,xK,cRegister,rRegister,cMax)
  nPoints = length(xK);
  allPointInitialRegister = xK*rRegister;
  yK(1:nPoints,1) = 0;
  
  for i = 1:nPoints
%       i;
      tempRRegister = allPointInitialRegister(i,:);
      evaluatedPoint = EvaluateInstruction(chromosome,tempRRegister,cRegister,cMax);
      yK(i,1) = evaluatedPoint;
  end

end

