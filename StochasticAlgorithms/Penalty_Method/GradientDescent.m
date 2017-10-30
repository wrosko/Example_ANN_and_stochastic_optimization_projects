function [mu, x1Star, x2Star] = GradientDescent( x0, mu, eta, T )
  
  initialGradient = Gradient(x0(1,1),x0(2,1),mu);

  modulusGradient =  abs(sqrt(initialGradient(1,1)^2 + initialGradient(2,1)^2));
  
  xJ = x0;
  while (modulusGradient >= T)
      
      xJGradient = Gradient(xJ(1,1),xJ(2,1),mu);
      xJ = xJ - eta*xJGradient;
      
      modulusGradient =  abs(sqrt(xJGradient(1,1)^2 + xJGradient(2,1)^2));
      
  end
  
  x1Star = xJ(1,1);
  x2Star = xJ(2,1);

end

