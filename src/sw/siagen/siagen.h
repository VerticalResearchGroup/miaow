#ifndef MIAOW_SIAGEN_H
#define MIAOW_SIAGEN_H

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "asm.h"
#include "helper.h"

#define MAX_INSTR 1000
#define MAX_OPS 50

#define INSTR_TYPES 4

#define SCALAR_ALU 0
#define VECTOR_ALU 1
#define SCALAR_MEM 2
#define VECTOR_MEM 3

typedef struct _instr
{
	int opcode;
	char op_str[30];
} Instr;

typedef struct _instr_sel 
{
	enum si_fmt_enum instr_type;
	Instr instr;
	void (*instr_func)(int);
} Instr_Sel;

void initializeInstrArr(int arr[MAX_INSTR]);
void printInstrsInArray(int arr[MAX_INSTR]);
void printAllUnitTests();

#endif
