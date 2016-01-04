#ifndef MIAOW_HELPER_H
#define MIAOW_HELPER_H

#include <stdio.h>
#include <stdlib.h>
#ifndef WIN32
#include <unistd.h>
#endif
#include <string.h>

#define MAX_IMM_VAL 50

// populate according to commandline values
// only one variable of this type
struct _configValues
{
	int scalar_alu;
	int vector_alu;
	
	int scalar_mem;
	int vector_mem;
	
	int scalar_reg;
	int vector_reg;

	int data_memory;
	int instr_count;

	int thrd_count;
	int w_thrd_cnt[40];
	int wfrt_count;
	int wgrp_count;

	int test_count;
	int unit_tests;
} typedef configValues;

void printInstruction32(void* instr);
void printInstruction64(void* instr);
void shuffleArray(int *arr, int size);
void usage(char *prog);
void parseArgs(int argc, char *argv[]);

void openOutputFiles();
void closeOutputFiles();
void writeConfigFile();
void writeDataMemFile();

#endif

