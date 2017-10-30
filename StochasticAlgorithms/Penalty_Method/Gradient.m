function gradient = Gradient( x1, x2, mu )
  gradient(1,1) = 2*(2*mu*x1*(x1^2+x2^2-1)+x1-1);
  gradient(2,1) = 4*(mu*x2*(x1^2+x2^2-1)+x2-2);
end

