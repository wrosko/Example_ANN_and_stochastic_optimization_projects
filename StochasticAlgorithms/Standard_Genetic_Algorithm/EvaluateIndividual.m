function fitnessValue = EvaluateIndividuals( x )
  
  gPartOne = (x(1,1)+x(1,2)+1)^2;
  gPartTwo = (19 - 14*x(1,1) + 3*x(1,1)^2 - 14*x(1,2) +6*x(1,1)*x(1,2)+ ...
      3*x(1,2)^2);
  gPartThree = (2*x(1,1)-3*x(1,2))^2;
  gPartFour = (18 - 32*x(1,1) + 12*x(1,1)^2 + 48*x(1,2)- 36*x(1,1)*x(1,2)+ ...
      27*x(1,2)^2);
  
  g = (1+gPartOne*gPartTwo)*(30+gPartThree*gPartFour);
  
  fitnessValue = 1/g;


end

