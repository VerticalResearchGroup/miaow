#include "siagen.h"
#include <time.h>
#ifdef WIN32
#include <Windows.h>
#include <strsafe.h>
#endif

extern configValues configs;

int instr_arr[MAX_INSTR];

int main(int argc, char *argv[])
{

    // populate configs
    parseArgs(argc, argv);
    srand((unsigned int)time(NULL));

    int i, j;

    if (configs.unit_tests == 1) {
        printAllUnitTests();
    }
    else {
#ifdef WIN32
        wchar_t folName[MAX_PATH];
        BOOL status;
#else
        char folName[40];
#endif

        for (j = 0; j < configs.test_count; j++)
        {
            // create folder
#ifdef WIN32
            StringCbPrintf(folName, MAX_PATH, L"test_%03d", j);
            status = CreateDirectory(folName, nullptr);
            status = SetCurrentDirectory(folName);
#else
            sprintf(folName, "test_%03d", j);
            mkdir(folName, S_IRWXU | S_IRGRP | S_IXGRP);
            chdir(folName);
#endif

            openOutputFiles();

            for (i = 0; i < configs.wgrp_count; i++) {
                // initialize array
                initializeInstrArr(instr_arr, MAX_INSTR);

                // randomize array
                shuffleArray(instr_arr, configs.instr_count);

                // print instructions
                printInstrsInArray(instr_arr);
            }

            writeConfigFile();
            writeDataMemFile();

            closeOutputFiles();

            // go to parent folder
#ifdef WIN32
            status = SetCurrentDirectory(L"..\\");
#else
            chdir("..");
#endif
        }
    }

    return 0;
}
