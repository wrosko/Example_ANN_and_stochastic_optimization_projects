function mutatedChromosome = Mutate(chromosome,mutationProbability,operators,rRegister,cRegister)
  
  nInstructions = length(chromosome/4);
  mutatedChromosome = chromosome;
  unionSet = [rRegister cRegister];
  
  for i = 1:4
      for j = i:4:nInstructions
          r = rand;                    
          if (r < mutationProbability)
              
              if (i == 1)
                  mutatedChromosome(j) = 1 + fix(rand*length(operators));
              end
              if (i == 2)
                  mutatedChromosome(j) = 1 + fix(rand*length(rRegister));
              end
              if (i == 3)
                  mutatedChromosome(j) = 1 + fix(rand*length(unionSet));
              end
              if (i == 4)
                  mutatedChromosome(j) = 1 + fix(rand*length(unionSet));
              end
          end
      end
  end

end

