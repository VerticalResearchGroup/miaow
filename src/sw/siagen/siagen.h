#ifndef MIAOW_SIAGEN_H
#define MIAOW_SIAGEN_H

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <string>
#include "asm.h"
#include "helper.h"

#define MAX_INSTR 1000
#define MAX_OPS 50

#define INSTR_TYPES 4

#define SCALAR_ALU 0
#define VECTOR_ALU 1
#define SCALAR_MEM 2
#define VECTOR_MEM 3

#define NO_REG -1
#define REG_VCCZ 251
#define REG_EXECZ 252
#define REG_SCC 253

typedef void(*instr_function)(int);

typedef struct _instr_dep
{
  bool branch_flg;
  int cond_reg;
} Instr_Dep;

typedef struct _instr
{
	int opcode;
	std::string op_str;
    Instr_Dep instr_dep;
} Instr;

typedef struct _instr_sel
{
	enum si_fmt_enum instr_type;
	Instr instr;
    instr_function instr_func;
} Instr_Sel;

void initializeInstrArr(int *arr, int array_size);
void printInstrsInArray(int arr[MAX_INSTR]);
void printAllUnitTests();

#endif
