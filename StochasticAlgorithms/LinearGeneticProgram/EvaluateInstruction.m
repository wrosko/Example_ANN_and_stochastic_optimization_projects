function evaluatedPoint = EvaluateInstruction(chromosome,tempRRegister,cRegister,cMax)

  nInstructions = length(chromosome)/4;

  instructionIndex = 0;

  for i = 1:nInstructions

      unionSet = [tempRRegister cRegister];
      instruction = chromosome(instructionIndex*4 +1:instructionIndex*4 +4);
      index1 = instruction(1);
      index2 = instruction(2);
      index3 = instruction(3);
      index4 = instruction(4);
      
      
      if index1 == 1
          tempRRegister(index2) = unionSet(index3) + unionSet(index4);
      elseif index1 == 2
          tempRRegister(index2) = unionSet(index3) - unionSet(index4);
      elseif index1 == 3
          tempRRegister(index2) = unionSet(index3) * unionSet(index4);
      elseif index1 == 4
          if (unionSet(index4) == 0 )
              tempRRegister(index2) = cMax;
          else
              
              tempRRegister(index2) = unionSet(index3) / unionSet( index4);
          end
      end
      instructionIndex = instructionIndex+1;

  end
  evaluatedPoint = tempRRegister(1);
end

