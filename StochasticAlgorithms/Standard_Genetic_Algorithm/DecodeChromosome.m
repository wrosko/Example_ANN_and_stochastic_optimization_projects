function x = DecodeChromosome( chromosome, numberOfVariables, variableRange )
  
  m = length(chromosome);
  n = numberOfVariables;
  k = m/n;
  
  bitIndex = 0;     %bitIndex is used as the 0th, 1, 2 ... chromosome index
                    %It is used to generalize the equation on line 15
  x(1:n) = 0.0;

  for i = 1:n
      
      for j = 1:k
                    
          x(1,i) = x(1,i) + chromosome(j+bitIndex*k)*2^(-j);
          
      end
      x(1,i) = -variableRange + (2*variableRange*x(1,i))/(1-2^(-k));
      bitIndex = bitIndex+1;
  end


end

