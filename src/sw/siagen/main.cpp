#include "siagen.h"
#include <time.h>

extern configValues configs;

int main(int argc, char *argv[])
{
	int instr_arr[MAX_INSTR];
	
	// populate configs
	parseArgs(argc, argv);
	srand(time(NULL));

	int i, j;

	if(configs.unit_tests == 1) {
		printAllUnitTests();
	}
	else {
		char folName[40];
		
		for (j = 0; j < configs.test_count; j++)
		{
			// create folder
			sprintf(folName, "test_%03d", j);
			mkdir(folName, S_IRWXU|S_IRGRP|S_IXGRP);
			chdir(folName);

			openOutputFiles();

			for(i = 0; i < configs.wgrp_count; i++) {
				// initialize array
				initializeInstrArr(instr_arr);

				// randomize array
				shuffleArray(instr_arr, configs.instr_count);

				// print instructions
				printInstrsInArray(instr_arr);
			}
		
			writeConfigFile();
			writeDataMemFile();

			closeOutputFiles();

			// go to parent folder
			chdir("..");
		}
	}
	
	return 0;
}
