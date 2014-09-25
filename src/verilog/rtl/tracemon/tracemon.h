#ifndef __TRACEMON_H__
#define __TRACEMON_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAX_NUM_OF_CU 4
#define MAX_WFS_IN_CU 40
#define MAX_INSTR_FLIGHT 20
#define MAX_STR 400
#define MAX_PRBUF 25600

typedef struct _trace_obj {
	int pc;
	//int instr_p1;
	//int instr_p2;
	//int numOfParts;
	int isBarrier;
	int timestamp;
	int complete;
	char buff[MAX_PRBUF];
} Trace_obj;

typedef struct _bases {
	int sgpr_base;
	int vgpr_base;
	int lds_base;
} Bases;

// helper function to write a string
void WriteString(int cuid, int wf, char* buff);

void InitializeTraceMon(int cuid);
void SetKernelId(int kernel_id);

void AddBases(int cuid, int wf, int sbase, int vbase, int lbase);
int GetSgprBase(int cuid, int wf);
int GetVgprBase(int cuid, int wf);
int GetLdsBase(int cuid, int wf);

void AddNewWavefront(int cuid, int tag, int wf);
void AddInstruction(int cuid, int wf, int pc, int is64, 
	int instr_lo, int instr_hi, int isBarrier, int timestamp);
void PrintAndDelete(int cuid, int wf, int pc);
void PrintAndDeleteOnBranch(int cuid, int wf, int pc, int taken);
void PrintAndDeleteBarrier(int cuid, int wf);
void PrintAndDeleteAll(int cuid, int wf);

void PrintVgpr(int cuid, int wf, int pc, int tid, int reg, int value);
void PrintVgprWithVcc(int cuid, int wf, int pc, int tid, int reg, int value, int vcc);
void PrintVVcc(int cuid, int wf, int pc, int tid, int vcc);
void PrintVSgpr(int cuid, int wf, int pc, int tid, int reg, int value);
void PrintVgprF(int cuid, int wf, int pc, int tid, int reg, int value);
void PrintVgprFWithVcc(int cuid, int wf, int pc, int tid, int reg, int value, int vcc);
void PrintSgpr(int cuid, int wf, int pc, int sel, int reg, int hival, int loval);
void PrintScc(int cuid, int wf, int pc, int value);
void PrintSgprWithScc(int cuid, int wf, int pc, int sel, int reg, int hival, int loval, int scc);
void PrintSgprExecScc(int cuid, int wf, int pc, int reg, int shival, int sloval, int ehival, int eloval, int scc);
void PrintVgprLoad(int cuid, int wf, int pc, int tid, int reg, int addr, int value);
void PrintVgprLoadDS(int cuid, int wf, int pc, int tid, int reg, int addr, int value);
void PrintSgprLoad(int cuid, int wf, int pc, int addr, int reg, int value);
void PrintVgprStore(int cuid, int wf, int pc, int tid, int addr, int reg, int value);
void PrintVgprStoreDS(int cuid, int wf, int pc, int tid, int addr, int reg, int value);
void PrintExec(int cuid, int wf, int pc, int sel, int hival, int loval);
void PrintVcc(int cuid, int wf, int pc, int sel, int hival, int loval);
void PrintM0(int cuid, int wf, int pc, int val);
void PrintExecWithScc(int cuid, int wf, int pc, int sel, int hival, int loval, int scc);
void PrintVccWithScc(int cuid, int wf, int pc, int sel, int hival, int loval, int scc);
void PrintM0WithScc(int cuid, int wf, int pc, int val, int scc);
void PrintEndLine(int cuid, int wf, int pc);

#endif /* __TRACEMON_H__ */
