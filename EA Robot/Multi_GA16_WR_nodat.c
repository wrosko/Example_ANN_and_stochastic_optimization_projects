#pragma config(Sensor, S1,		 rightRight,					sensorSONAR)
#pragma config(Sensor, S2,		 rightFront,					sensorSONAR)
#pragma config(Sensor, S3,		 leftFront,						sensorSONAR)
#pragma config(Sensor, S4,		 leftLeft,						sensorSONAR)

#pragma config(Motor,	 motorA,					motorA,				 tmotorNormal, PIDControl, reversed, encoder)
#pragma config(Motor,	 motorC,					motorC,				 tmotorNormal, PIDControl, reversed, encoder)
//==========================================================
/*
This program is a modification of Peter Cole's original "TestGAc-struct.pc."
It measures the fitness of individuals in xmax number of generations of simple 4 sonar wall avoider ANNs
The ANN = 4(prox) x 2 (motor)
Fitness is defined as the inverse of the number of bumps (or number of times the robot approaches within 10 cm of the wall)
*/

//==========================================================

// property declarations
// Here we define our declarations. They include floating pointing, integer, boolean variables, 
// structures, and the functions that we will later use.

TFileHandle		hFileHandle;											// this command identifies a label that will keep track of our file
TFileIOResult nIOResult;												// will store our IO (input/output)results
string				sFileName = "dataFile.txt";							// the name of our file; notice that it is a "string variable" or a string of characters; in this case ASCII characters
int						nFileSize = 1000000000;							// will set and store our file size; increased here from 10,000 to 10,000,000

float MOTR[2] = {0.000, 0.000};
float PMWTS[8] = {0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000};
float PROX[4] = {0.000, 0.000, 0.000, 0.000};
float V = 0.00;
float DV = 0.00;
float one_minus_i = 0.00;
float MaxProx = 0.00;
float FitValue = 0.00;
int		fittestGenotype;
bool	crossoverHappened = false;
bool firstgen = true;
int offspring1;
int offspring2;
int x =1;
int xmax = 3;                           //////SPECIFY NUMBER OF GENERATIONS HERE
int M=0;                                //Set counter for keeping track of index in boolean array
//int N=0;
bool firstTimeArray[30];                //CHANGE ARRAY SIZE TO xmax * NUMBER OF GENERATIONS
//bool firstTimeCrossArray[6];            //writeDataFileForCrossoverGenotype(N+k); in rungeneration() is commented out

//genotype struct to handle properties of each genotype
struct {
	int genome[8][4];
	string chromoArray[8];
	int decimalArray[8];
	float normalizedArray[8];
	int fitnessValue;
} genotypeStruct;

genotypeStruct genomes[10];

//crossover struct to handle properties of crossover
struct {
	int offspringGenome[8][4];
	string chromoArray[8];
	int decimalArray[8];
	float normalizedArray[8];
	int fitnessValue;
} crossoverGenotypeStruct;

crossoverGenotypeStruct crossoverGenomes[2];

// function declarations
void randomGenotypes(bool firstgen);
void expressGenes();
void seedWeightsForGenotype(int genotypeIndex);
void look();
void sense();
void MaxValue();
void FITNESS();
void fitnessForGenotype(int genotypeIndex);
void rankGenotypes();
void crossover();
void go();
void avoid();
void rungeneration();


//RobotC does not have a defined power function, so we create our own below. We can then call on this function later.

#define pow(x,a)	( exp((a)*log(x)) ) // define our own math power function, x^a = e^(a*Ln(x)).
// Since e^Ln(x)=x, e^(a*Ln(x)) = x^a.

//==========================================================
//The main function of the program lies below. Here we initially call on the initDataFile() function. This creates the data file that will contain the genotypes
//for xmax generations. A while loop is initiated where x is initially 1. After each generation run, the value of x increases by 1. The loop stops once x is greater than
//xmax. Within the while loop, randomGenotypes() is called. During the first generation the argument firstgen is true. This triggers one part of the randomGenotypes() function.
//During successive generations the argument is false, and the second part of the randomGenotypes() function is called on. expressGenes() is then called. This function
//converts the genotype to weights that can be expressed by the robot. The converted genes are then run in rungeneration(). The integer variabels in main() are used for indexing
//the generation, and the individual number.
//==========================================================

task main()
{
  while(x <= xmax)
  {
	randomGenotypes(firstgen);
	expressGenes();

  rungeneration();

  x = x +1;
  M = M +10;
  N = N +0;		//this might not be necessary
  firstgen = false;
  crossoverHappened = false;
  N = N + 10;
  PlaySound(soundFastUpwardTones);
  }
}




//==========================================================
//The genotypes for the respective individuals are created within this function. If the program is in the first generation of indivduals, then
//each of the ten individuals is seeded randomly with bits. When the program is running any generation greater than 1, 10 individuals are randomly
//seeded. After the generation is randomly seeded, the two offspring from the previous generation are swapped into the generation.
//==========================================================
void randomGenotypes(bool firstgen)
{
  if(x == 0)
  {
	for (int k = 0; k < 10; k++)	// 8 rows = 8 genes
	{
		for (int i = 0; i < 8; i++)	 // 8 rows = 8 genes
		{
			for (int j = 0; j < 4; j++)	 // cols = bits
			{
				genomes[k].genome[i][j] = random(1); //seed genome populations with random bits = 4 bit binary string
			}
		}
	}

}
else

{
  for (int k = 0; k < 10; k++)	// 8 rows = 8 genes
	{
		for (int i = 0; i < 8; i++)	 // 8 rows = 8 genes
		{
			for (int j = 0; j < 4; j++)	 // cols = bits
			{
				genomes[k].genome[i][j] = random(1); //seed genome populations with random bits = 4 bit binary string
			}
		}
	}
	genomes[offspring1].genome = crossoverGenomes[0].offspringGenome; //Seed positions of the best and random genotype with the crossed over pair
	genomes[offspring2].genome = crossoverGenomes[1].offspringGenome;

}

}


//==========================================================
//expressGenes() takes the genotype of each individual and converts the bits into weights that will be used when the individual is run. This is
//called on in the main function as well as the rungeneration() function. In the main function it is called on prior to a crossover
//so each member of the generation has their respective genotypes converted to weights that can be expressed. When called on in the
//rungeneration function, the two offspring genotypes are expressed. 
//==========================================================

void expressGenes()
{
	if(crossoverHappened == false)
	{
		for (int k = 0; k < 10; k++) // for each of 10 individuals
		{
			for (int i = 0; i < 8; i++)	 // for each of 8 rows = 8 genotypes
			{
				int decimalValue = genomes[k].genome[i][0]*pow(2, 3-0) + genomes[k].genome[i][1]*pow(2, 3-1) + genomes[k].genome[i][2]*pow(2, 3-2) + genomes[k].genome[i][3]*pow(2, 3-3); // genome(gene?)Element*pow(base2, ((#bits-1) - elementIndexValue)) + (...)

				// calculate "v"; convert genes (binary strings) to integer values between 0 and 15
				string gString1 = "";
				string gString2 = "";
				StringFormat(gString1, "%d%d", genomes[k].genome[i][0], genomes[k].genome[i][1]);
				StringFormat(gString2, "%d%d", genomes[k].genome[i][2], genomes[k].genome[i][3]);

				// fill arrays with corresponding values
				genomes[k].chromoArray[i] = gString1 + gString2; //the 8 GENES in the artificial chromosome; concatenate genome strings (4-bit) for each population and write to chromoArray
				genomes[k].decimalArray[i] = decimalValue; // the calculation of "v" in Pfeifer & Scheier's (1998) program; write decimal values resultant from binary to decimal conversion to decimalArray
				genomes[k].normalizedArray[i] = (float) decimalValue/15 - 0.5; //the expression of each of the 8 GENES as a weight (Wij);; normalize decimal values to between -0.5 and 0.5 for weight expression and write to normalizedArray
			}
		}
	}
	else
	{
		for (int k = 0; k < 2; k++)
		{
			for (int i = 0; i < 8; i++)	 // 8 rows = 8 genes
			{
				int decimalValue = crossoverGenomes[k].offspringGenome[i][0]*pow(2, 3-0) + crossoverGenomes[k].offspringGenome[i][1]*pow(2, 3-1) + crossoverGenomes[k].offspringGenome[i][2]*pow(2, 3-2) + crossoverGenomes[k].offspringGenome[i][3]*pow(2, 3-3); // genome(gene?)Element*pow(base2, ((#bits-1) - elementIndexValue)) + (...)

				// convert integer values in genome to 4-bit strings
				string gString1 = "";
				string gString2 = "";
				StringFormat(gString1, "%d%d", crossoverGenomes[k].offspringGenome[i][0], crossoverGenomes[k].offspringGenome[i][1]);
				StringFormat(gString2, "%d%d", crossoverGenomes[k].offspringGenome[i][2], crossoverGenomes[k].offspringGenome[i][3]);

				// fill arrays with corresponding values
				crossoverGenomes[k].chromoArray[i] = gString1 + gString2; //the 8 GENES in the artificial chromosome; concatenate genome strings (4-bit) for each population and write to chromoArray
				crossoverGenomes[k].decimalArray[i] = decimalValue; // the calculation of "v" in Pfeifer & Scheier's (1998) program; write decimal values resultant from binary to decimal conversion to decimalArray
				crossoverGenomes[k].normalizedArray[i] = (float) decimalValue/15 - 0.5; //the expression of each of the 8 GENES as a weight (Wij);; normalize decimal values to between -0.5 and 0.5 for weight expression and write to normalizedArray
			}
		}
	}
}

//==========================================================
//rungeneration() actually runs the current generation. For individuals 1-10 the function seeds the weights, records values of the sensors with look()
//and sense(), finds the fitness of the genotype, and then calls on the avoid function so the robot either aoids a wall if there is something 
//detected, or goes forward until something is picked up by the sensor. Once all generations have been run, then the function calls on the rankGenotypes()
//function. Here the best genotype is taken, then it is crossed with a random genotype. The result is two offspring that then have their genes expressed.
//The individuals are then run. 
//==========================================================


void rungeneration()
{
  for (int k = 0; k < 10; k++)
	{
		ClearTimer(T1);
		while ((time10(T1)/100) < 5) // run each individual for 15 seconds
		{
			seedWeightsForGenotype(k);
			look();
			sense();
			fitnessForGenotype(k);
			avoid();

		}

		PlaySound(soundBlip);
		motor[motorA] = 0;
		motor[motorC] = 0;
		wait1Msec(4000);

		if (k == 9)
		{
			PlaySound(soundBeepBeep);
			rankGenotypes();
			crossover();
			expressGenes();

			for (int k = 0; k < 2; k++)
			{
				ClearTimer(T1);
				while ((time10(T1)/100) < 15)
				{
					seedWeightsForGenotype(k);
					look();
					sense();
					fitnessForGenotype(k);
					avoid();
					//writeDataFileForCrossoverGenotype(N+k);
				}

				PlaySound(soundBlip);
				motor[motorA] = 0;
				motor[motorC] = 0;
				wait1Msec(4000);
			}
		}
	}
}
//==========================================================
void


//==========================================================
//The weights for the Genotypes are assigned here before and after a crossover happens. This is necessary to carry the information stored in the respective
//genotypes.
//==========================================================

void seedWeightsForGenotype(int genotypeIndex)
{
	if(crossoverHappened == false)
	{
		for (int i = 0; i < 8; i++)
		{
			PMWTS[i] = genomes[genotypeIndex].normalizedArray[i];
		}
	}
	else
	{
		for (int i = 0; i < 8; i++)
		{
			PMWTS[i] = crossoverGenomes[genotypeIndex].normalizedArray[i];
		}
	}
}

//==========================================================
//look() displays the current sensor values. This is handy for debugging or trying to figure out how the robot is responding in real time to different
//environmental changes.
//==========================================================

void look()
{
	nxtDisplayCenteredTextLine(3,"S1: %d", SensorValue(S1));
	nxtDisplayCenteredTextLine(4,"S2: %d", SensorValue(S2));
	nxtDisplayCenteredTextLine(5,"S3: %d", SensorValue(S3));
	nxtDisplayCenteredTextLine(6,"S4: %d", SensorValue(S4));
	wait1Msec(250);
}

//==========================================================
//sense() takes the sensor values, and then assigns them weight values (PROX[x]). They are then used to determine the value of the two motors. It is 
//necessary to ensure that this layer of the neural network is organized in the manner that the programmer wants. Either crossed connections or parallel
//connections.
//==========================================================

void sense()
{
	PROX[0] = 1 - (float)SensorValue(rightRight)/255; // converts sonar values into proximity values betwen 0.00 and 1.00
	PROX[1] = 1 - (float)SensorValue(rightFront)/255;
	PROX[2] = 1 - (float)SensorValue(leftFront)/255;
	PROX[3] = 1 - (float)SensorValue(leftLeft)/255;

	MOTR[0] = abs(PROX[0] * PMWTS[0] + PROX[1] * PMWTS[1] + PROX[2] * PMWTS[2] + PROX[3] * PMWTS[3]) * 20; // initial weights will be between -0.05 and 0.05; initial MOTR[i] values will be between -2 and 2.
	MOTR[1] = abs(PROX[0] * PMWTS[4] + PROX[1] * PMWTS[5] + PROX[2] * PMWTS[6] + PROX[3] * PMWTS[7]) * 20; // multiplying by 5 gives an initial maximum motor value of 10

}

//==========================================================
//This function simply calculates the fitness depending upon how many times the individual gets close to a wall. The more times it gets really close,
//the worse the fitness is. The more times it gets within a reasonable distance, the more fit the robot is.
//==========================================================
void fitnessForGenotype(int genotypeIndex) // calculates fitness relative to the number of times the robot gets within 8cm of the wall
{

	FITNESS();

	if(crossoverHappened == false)
	{
		// if (PROX[0] < 8 || PROX[1] < 8 || PROX[2] < 8 || PROX[3] < 8)
		// {
		genomes[genotypeIndex].fitnessValue = genomes[genotypeIndex].fitnessValue + FitValue; // genomes[genotypeIndex].fitnessValue - 1;

		// }
	}
	else
		//	{
	// if (PROX[0] < 8 || PROX[1] < 8 || PROX[2] < 8 || PROX[3] < 8)
	{
		crossoverGenomes[genotypeIndex].fitnessValue = crossoverGenomes[genotypeIndex].fitnessValue + FitValue; //crossoverGenomes[genotypeIndex].fitnessValue - 1;
	}
	// }
}

//==========================================================
//FITNESS() calculates the fitness of the robot based upon the motor speeds, the square difference and the encouragement of avoiding obstacles.
//==========================================================

void FITNESS()
{
	MaxValue();
	V = MOTR[0] * MOTR[1] * 0.5; //calculate the average motor speed
	DV = 1- sqrt(abs(MOTR[0] - MOTR[1])); // calculate the square of the difference between the motor speeds
	one_minus_i = 1 - MaxProx; //Encourage obstacle avoidance
	FitValue = (float) V * DV * one_minus_i;
}

//==========================================================
//Returns the maxvalue of the closest proximity sensor. 
//==========================================================
void MaxValue()
{
	// calculate the	value of closest proximity sensor, the one with the highest proximity value
	MaxProx = PROX[0];
	for (int i = 0; i < 4; i++)
	{
		if (PROX[i] > MaxProx)
		{
			MaxProx = PROX[i];
		}
	}
}

//==========================================================
//Depending on the weights assoiated with MOTORA and MOTORC, the robot reacts to the environment differently. The reaction is similar to the 
//Braitenburg vehicles we work with. If there is nothing that triggers the turning reaction of the robot, the robot will continue moving forward.
//==========================================================

void avoid()
{
	if (SensorValue(S1) < 25 || SensorValue(S2) < 25)
	{
		motor[motorA] = (50 - (SensorValue(S2)/20)); // negatively couple the ipsalateral motor inverting the sensor values
		motor[motorC] = (SensorValue(S3)/20);	 // positively couple the contralateral motor
		wait1Msec(50); // wait 250 milliseconds; we have found that inserting these wait commands at the end of extended procedures helps keep the program from getting buggy
	}

	if (SensorValue(S3) < 25 || SensorValue(S4) < 25)
	{
		motor[motorA] = (SensorValue(S2)/20); // negatively couple the ipsalateral motor inverting the sensor values
	motor[motorC] = (50 - SensorValue(S3)/20);	 // psotively couple the contralateral motor
	wait1Msec(50); // wait 250 milliseconds; we have found that inserting these wait commands at the end of extended procedures helps keep the program from getting buggy
}

else
{
	go();
}
}


//=========================================================
//Simply a move forward statement at a value between 0 and 1 that is associated with the weights of the motors.
//=========================================================

void go()
{
	motor[motorA] = MOTR[0];
	motor[motorC] = MOTR[1];
	wait1Msec(250);
}

//=========================================================
//The genotypes are searched through and the fittest one is returned with the below function. 
//=========================================================
void rankGenotypes()
{
	int fittestGenotypeValue;
	fittestGenotypeValue = genomes[0].fitnessValue;
	fittestGenotype = 0;

	for (int k = 1; k < 10; k++)
	{
		if (genomes[k].fitnessValue > fittestGenotypeValue)
		{
			fittestGenotype = k;
		}
		else
			if (k == 9)
		{
			string fittestString = "";
			string genotypeString = "";
			StringFormat(fittestString, "fittest: %d", fittestGenotype);
			genotypeString = genomes[fittestGenotype].chromoArray[0] + genomes[fittestGenotype].chromoArray[1] + genomes[fittestGenotype].chromoArray[2] + genomes[fittestGenotype].chromoArray[3] + genomes[fittestGenotype].chromoArray[4] + genomes[fittestGenotype].chromoArray[5] + genomes[fittestGenotype].chromoArray[6] + genomes[fittestGenotype].chromoArray[7];

		}
	}
}

//==========================================================
//The crossover function is one of the last functions called. Chooses a random point in the most fit and also in the random genotype. At this point,
//the fittest genotype is offspring1. This is stored as an index. A random genotype is chosen as long as it is not the fittest genotype. If the crossover
//point chosen happens to be 0, a new crossover point is randomly found until it is not 0. Then the corssover happens. The two genotypes are split at
//their respective marks, and then reassembled. Upon finding the offspring, a random point is found in each string, and the bit is modified/mutated.
//==========================================================
void crossover()
{
	crossoverHappened = true;

	int crossoverPointX = random(7);
	int crossoverPointY = random(3);
	int randomGenotype = random(9);

	offspring1 = fittestGenotype;               //obtain offspring1 index


	if (randomGenotype == fittestGenotype)
	{
		randomGenotype = random(9);
	}
	offspring2 = randomGenotype;
	if (crossoverPointX == 0)crossoverPointX = 4;
	if (crossoverPointY == 0)crossoverPointY = random(3);

	for (int i = 0; i < crossoverPointX; i++)
	{
		if (i == (crossoverPointX-1))
		{
			for (int j = 0; j < crossoverPointY; j++)
			{
				crossoverGenomes[0].offspringGenome[i][j] = genomes[fittestGenotype].genome[i][j];
				crossoverGenomes[1].offspringGenome[i][j] = genomes[randomGenotype].genome[i][j];
			}
		}
		else
		{
			for (int j = 0; j < 4; j++)
			{
				crossoverGenomes[0].offspringGenome[i][j] = genomes[fittestGenotype].genome[i][j];
				crossoverGenomes[1].offspringGenome[i][j] = genomes[randomGenotype].genome[i][j];
			}
		}
	}

	for (int i = crossoverPointX-1; i < 8; i++)
	{
		if (i == crossoverPointX-1)
		{
			for (int j = crossoverPointY; j < 4; j++)
			{
				crossoverGenomes[0].offspringGenome[i][j] = genomes[randomGenotype].genome[i][j];
				crossoverGenomes[1].offspringGenome[i][j] = genomes[fittestGenotype].genome[i][j];
			}
		}
		else
		{
			for (int j = 0; j < 4; j++)
			{
				crossoverGenomes[0].offspringGenome[i][j] = genomes[randomGenotype].genome[i][j];
				crossoverGenomes[1].offspringGenome[i][j] = genomes[fittestGenotype].genome[i][j];
			}
		}
	}

	wait1Msec(250);

	int mutateX = random(7);
	int mutateY = random(3);

	if (crossoverGenomes[0].offspringGenome[mutateX][mutateY] == 0)
	{
		crossoverGenomes[0].offspringGenome[mutateX][mutateY] = 1;
	}
	else
	{
		crossoverGenomes[0].offspringGenome[mutateX][mutateY] = 0;
	}


	wait1Msec(250);
}

//}=========================================================


