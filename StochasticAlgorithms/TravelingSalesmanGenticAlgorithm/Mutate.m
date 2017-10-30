function mutatedChromosome = Mutate( chromosome, mutationProbability )
  
  nGenes = length(chromosome)-1;
  mutatedChromosome = chromosome(1,1:nGenes);
  
  for j = 1:nGenes
      r = rand;
      
      tempIndexRandomGene = 0;
      tempMutatedChromosome = mutatedChromosome;
      
      if (r < mutationProbability)
          tempIndexRandomGene = 1 + fix(rand*nGenes);
          tempMutatedChromosome(j) = mutatedChromosome(tempIndexRandomGene);
          tempMutatedChromosome(tempIndexRandomGene) = mutatedChromosome(j);
          mutatedChromosome = tempMutatedChromosome;      
      end
      
  end
  mutatedChromosome(1,nGenes+1) = mutatedChromosome(1,1);

end

