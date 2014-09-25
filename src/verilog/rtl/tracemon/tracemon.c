#include "tracemon.h"

// comment the below line for release version
//#define __DEBUG_TRACEMON__

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
Bases allBases[MAX_NUM_OF_CU][MAX_WFS_IN_CU];

Trace_obj objects[MAX_NUM_OF_CU][MAX_WFS_IN_CU][MAX_INSTR_FLIGHT];
int numOfObjs[MAX_NUM_OF_CU][MAX_WFS_IN_CU];
char outFileName[MAX_NUM_OF_CU][MAX_WFS_IN_CU][50];

int kernel_id = 0;

// initializing the size of all wavefronts to 0
void InitializeTraceMon(int cuid)
{
	int i, j;
	
	for(i = 0; i < MAX_NUM_OF_CU; i++) {
		for(j = 0; j < MAX_WFS_IN_CU; j++) {
			numOfObjs[i][j] = 0;
			strcpy(outFileName[i][j], "unint.out");
		}
	}
}

void SetKernelId(int kid) {
	kernel_id = kid;
}

void AddBases(int cuid, int wf, int sbase, int vbase, int lbase)
{
	allBases[cuid][wf].sgpr_base = sbase;
	allBases[cuid][wf].vgpr_base = vbase;
	allBases[cuid][wf].lds_base = lbase;
}

int GetSgprBase(int cuid, int wf)
{
	return allBases[cuid][wf].sgpr_base;
}

int GetVgprBase(int cuid, int wf)
{
	return allBases[cuid][wf].vgpr_base;
}

int GetLdsBase(int cuid, int wf)
{
	return allBases[cuid][wf].lds_base;
}

int checkIfFolderExists(int kernel_id) {
	struct stat s;
	char buff[20];

	sprintf(buff, "kernel_%d", kernel_id);
	int err = stat(buff, &s);

	if(-1 == err) {
		//if(ENOENT == errno) {
			fprintf(stderr, "Kernel folder doesn't exist: %s\n", buff);
		//} else {
		//	fprintf(stderr, "Stat error: %s\n", buff);
		//}
	} 
	else {
		if(S_ISDIR(s.st_mode)) {
			return 1;
		} 
		else {
			fprintf(stderr, "Kernel file found!: %s\n", buff);
		}
	}

	return 0;
}

// adds the string to be prepended for a wf
void AddNewWavefront(int cuid, int tag, int wf) {
	char buff[50];
	FILE *fp;

	int ret = checkIfFolderExists(kernel_id);

	if(ret == 1) {
		sprintf(buff, "kernel_%d/tracemon_%d_%d_%d.out", 
			kernel_id, kernel_id, (tag/16), (tag%16));
	}
	else {
		sprintf(buff, "tracemon_%d_%d_%d.out", 
			kernel_id, (tag/16), (tag%16));
	}

	strcpy(outFileName[cuid][wf], buff);
	fp = fopen(outFileName[cuid][wf], "w");
	fclose(fp);
	Logging(cuid, wf, 0, buff, NULL);
}

void Logging(int cuid, int wf, int pc, char *action, char *xtra) {
	FILE *fp;
	char buff[300];
	fp = fopen("tracemon.log", "a");
	sprintf(buff, "%s : %d %d %d\n", action, cuid, wf, pc);
	fprintf(fp, "%s", buff);

	if(xtra != NULL) { fprintf(fp, "%s", xtra); }
	
	fclose(fp);
}

// adds an instruction to tracked set for a wavefront
void AddInstruction(int cuid, int wf, int pc, int is64, 
	int instr_lo, int instr_hi, int isBarrier, int timestamp)
{
	Logging(cuid, wf, pc, "Add", NULL);

	pthread_mutex_lock(&lock);

	int max = numOfObjs[cuid][wf];

	objects[cuid][wf][max].pc = pc;
	strcpy(objects[cuid][wf][max].buff, "");

	if(is64 == 1) {	
		//objects[cuid][wf][max].instr_p1 = instr_lo;
		//objects[cuid][wf][max].instr_p2 = instr_hi;
		//objects[cuid][wf][max].numOfParts = 2;
		sprintf(objects[cuid][wf][max].buff, 
			" // %08X: %08X %08X\n", pc, instr_lo, instr_hi);
	}
	else {
		//objects[cuid][wf][max].instr_p1 = instr_lo;
		//objects[cuid][wf][max].numOfParts = 1;
		sprintf(objects[cuid][wf][max].buff, 
			" // %08X: %08X\n", pc, instr_lo);
	}

	objects[cuid][wf][max].isBarrier = isBarrier;
	objects[cuid][wf][max].complete = 0;
	numOfObjs[cuid][wf] = numOfObjs[cuid][wf] + 1;

	pthread_mutex_unlock(&lock);
}

int findInstrIndex(int cuid, int wf, int pc)
{
	int max = numOfObjs[cuid][wf];
	int i;
	
	for(i = 0; i < max; i++) {
		if(objects[cuid][wf][i].pc == pc) break;
	}

	if(i == max) return -1;
	else return i;
}

int deleteInstrIndex(int cuid, int wf, int idx)
{
	int max = numOfObjs[cuid][wf];
	int i, j;

	for(i = idx, j = 0; i < max; i++, j++) {
		objects[cuid][wf][j] = objects[cuid][wf][i];
	}
	
	numOfObjs[cuid][wf] = numOfObjs[cuid][wf] - idx;
}

// Called when retiring an instruction
void PrintAndDelete(int cuid, int wf, int pc)
{
	Logging(cuid, wf, pc, "Delete", NULL);

	pthread_mutex_lock(&lock);

	int idx = findInstrIndex(cuid, wf, pc);

	if(objects[cuid][wf][idx].complete == 1) {
		char buff[100];
		sprintf(buff, "PrintAndDelete: wfid=%d pc=0x%X in CU%d has already retired.\n", 
			wf, pc, cuid);
		WriteString(cuid, wf, buff);

		pthread_mutex_unlock(&lock);
		return;
	}

	objects[cuid][wf][idx].complete = 1;

	if(idx == -1) {
		char buff[100];
		sprintf(buff, "PrintAndDelete: wfid=%d pc=0x%X in CU%d not found.\n", 
			wf, pc, cuid);
		WriteString(cuid, wf, buff);
		//return;
	}
	else if(idx == 0) {
		int i;
		int max = numOfObjs[cuid][wf];
		
		for(i = 0; i < max; i++) {
			if(objects[cuid][wf][i].complete == 1) {
				WriteString(cuid, wf, objects[cuid][wf][i].buff);
			}
			else {
				break;
			}
		}

		deleteInstrIndex(cuid, wf, i);
	}

	pthread_mutex_unlock(&lock);
}

// Called when retiring a branch instruction
void PrintAndDeleteOnBranch(int cuid, int wf, int pc, int taken)
{
	Logging(cuid, wf, pc, "DeleteOnBr", NULL);

	pthread_mutex_lock(&lock);

	int idx = findInstrIndex(cuid, wf, pc);
	objects[cuid][wf][idx].complete = 1;

	if((idx != -1) && (taken == 1)) {
		numOfObjs[cuid][wf] = idx + 1;
	}

	if(idx == -1) {
		char buff[100];
		sprintf(buff, "PrintAndDeleteOnBranch: wfid=%d pc=0x%X in CU%d not found.\n", 
			wf, pc, cuid);
		WriteString(cuid, wf, buff);
		//return;
	}
	else if(idx == 0) {
		int i;
		int max = numOfObjs[cuid][wf];
		
		for(i = 0; i < max; i++) {
			if(objects[cuid][wf][i].complete == 1) {
				WriteString(cuid, wf, objects[cuid][wf][i].buff);
			}
			else {
				break;
			}
		}

		deleteInstrIndex(cuid, wf, i);
	}

	pthread_mutex_unlock(&lock);
}

// Called when retiring a barrier instruction
void PrintAndDeleteBarrier(int cuid, int wf)
{
	Logging(cuid, wf, 0, "DeleteOnBar", NULL);

	pthread_mutex_lock(&lock);

	int idx;
	int max = numOfObjs[cuid][wf];

	for(idx = 0; idx < max; idx++) {
		if(objects[cuid][wf][idx].isBarrier == 1) break;
	}

	objects[cuid][wf][idx].complete = 1;

	if(idx == max) {
		char buff[100];
		sprintf(buff, "PrintAndDeleteBarrier: wfid=%d in CU%d not found.\n", 
			wf, cuid);
		WriteString(cuid, wf, buff);
		//return;
	}
	else if(idx == 0) {
		int i;
		
		for(i = 0; i < max; i++) {
			if(objects[cuid][wf][i].complete == 1) {
				WriteString(cuid, wf, objects[cuid][wf][i].buff);
			}
			else {
				break;
			}
		}

		deleteInstrIndex(cuid, wf, i);
	}

	pthread_mutex_unlock(&lock);
}

// Called during descheduling of a wavefront
void PrintAndDeleteAll(int cuid, int wf)
{
	Logging(cuid, wf, 0, "DeleteAll", NULL);

	pthread_mutex_lock(&lock);

	int max = numOfObjs[cuid][wf];
	int i;

	if(max > 0) objects[cuid][wf][max-1].complete = 1;
	
	for(i = 0; i < max; i++) {
		if(objects[cuid][wf][i].complete != 1) {
			char buff[100];
			sprintf(buff, "PrintAndDeleteAll: wfid=%d pc=0x%X in CU%d has not retired.\n", 
				wf, objects[cuid][wf][i].pc, cuid);
			WriteString(cuid, wf, buff);
		}

		WriteString(cuid, wf, objects[cuid][wf][i].buff);
	}
	
	numOfObjs[cuid][wf] = 0;
	strcpy(outFileName[cuid][wf], "uninit.out");

	pthread_mutex_unlock(&lock);
}

/************************************************************************/
/*                      Region: Printing trace                          */
/************************************************************************/

void WriteString(int cuid, int wf, char *buff)
{
	FILE *fp;	
	fp = fopen(outFileName[cuid][wf], "a");
	fprintf(fp, "%s", buff);
	fclose(fp);

	Logging(cuid, wf, 0, "WString", buff);
}

void PrintVgpr(int cuid, int wf, int pc, int tid, int reg, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	sprintf(buff, "t%d: V%d<=(%d) ", tid, reg, value);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVgprWithVcc(int cuid, int wf, int pc, int tid, int reg, int value, int vcc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	sprintf(buff, "t%d: V%d<=(%d) wf_id%d: vcc<=(%d) ", tid, reg, value, tid, vcc);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVVcc(int cuid, int wf, int pc, int tid, int vcc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	sprintf(buff, "wf_id%d: vcc<=(%d) ", tid, vcc);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVSgpr(int cuid, int wf, int pc, int tid, int reg, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	sprintf(buff, "wf_id%d: S[%d:+1]<=(%d) ", tid, reg, value);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVgprF(int cuid, int wf, int pc, int tid, int reg, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	float *ptr = (float *)&value;

	sprintf(buff, "t%d: V%d<=(%gf) ", tid, reg, *ptr);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVgprFWithVcc(int cuid, int wf, int pc, int tid, int reg, int value, int vcc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	float *ptr = (float *)&value;

	sprintf(buff, "t%d: V%d<=(%gf) wf_id%d: vcc<=(%d) ", tid, reg, *ptr, tid, vcc);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintSgpr(int cuid, int wf, int pc, int sel, int reg, int hival, int loval)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	
	if(sel == 1)
		sprintf(buff, "S%d<=(%d) \n", reg, loval);
	if(sel == 3)
		sprintf(buff, "S%d<=(%d) S%d<=(%d) \n", reg, loval, reg+1, hival);

	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintScc(int cuid, int wf, int pc, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	sprintf(buff, "scc<=(%d) \n", value);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintSgprWithScc(int cuid, int wf, int pc, int sel, int reg, int hival, int loval, int scc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	
	if(sel == 1)
		sprintf(buff, "S%d<=(%d) scc<=(%d) \n", reg, loval, scc);
	if(sel == 3)
		sprintf(buff, "S%d<=(%d) S%d<=(%d) scc<=(%d) \n", 
			reg, loval, reg+1, hival, scc);

	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintSgprExecScc(int cuid, int wf, int pc, int reg, int shival, int sloval, int ehival, int eloval, int scc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	
	sprintf(buff, "S%d<=(%d) S%d<=(%d) exec_lo<=(%d) exec_hi<=(%d) scc<=(%d) \n", 
			reg, sloval, reg+1, shival, eloval, ehival, scc);

	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVgprLoad(int cuid, int wf, int pc, int tid, int reg, int addr, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	float *ptr = (float *)&value;

	sprintf(buff, "t%d: V%d<=(%d)(%d,%gf) ", tid, reg, addr, value, *ptr);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVgprLoadDS(int cuid, int wf, int pc, int tid, int reg, int addr, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);

	sprintf(buff, "t%d: V%d<=(%d)(%d) ", tid, reg, addr, value);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintSgprLoad(int cuid, int wf, int pc, int addr, int reg, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	float *ptr = (float *)&value;

	sprintf(buff, "S%d<=(%d)(%d,%gf) ", reg, addr, value, *ptr);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVgprStore(int cuid, int wf, int pc, int tid, int addr, int reg, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	float *ptr = (float *)&value;

	sprintf(buff, "t%d: (%d)<=V%d(%d,%gf) ", tid, addr, reg, value, *ptr);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVgprStoreDS(int cuid, int wf, int pc, int tid, int addr, int reg, int value)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);

	sprintf(buff, "GDS?:0 DS[%d]<=(%d) ", addr, value);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintExec(int cuid, int wf, int pc, int sel, int hival, int loval)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);

	if(sel == 1)
		sprintf(buff, "S126<=(%d) \n", loval);
	if(sel == 2)
		sprintf(buff, "S127<=(%d) \n", hival);
	if(sel == 3)
		sprintf(buff, "S126<=(%d) S127<=(%d) \n", loval, hival);
	
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintVcc(int cuid, int wf, int pc, int sel, int hival, int loval)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	
	if(sel == 1)
		sprintf(buff, "S106<=(%d) \n", loval);
	if(sel == 2)
		sprintf(buff, "S107<=(%d) \n", hival);
	if(sel == 3)
		sprintf(buff, "S106<=(%d) S107<=(%d) \n", loval, hival);
	
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintM0(int cuid, int wf, int pc, int val)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	sprintf(buff, "S124<=(%d) \n", val);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintExecWithScc(int cuid, int wf, int pc, int sel, int hival, int loval, int scc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);

	if(sel == 1)
		sprintf(buff, "S126<=(%d) scc<=(%d)\n", loval, scc);
	if(sel == 2)
		sprintf(buff, "S127<=(%d) scc<=(%d)\n", hival, scc);
	if(sel == 3)
		sprintf(buff, "S126<=(%d) S127<=(%d) scc<=(%d)\n", loval, hival, scc);
	
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}
void PrintVccWithScc(int cuid, int wf, int pc, int sel, int hival, int loval, int scc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	
	if(sel == 1)
		sprintf(buff, "S106<=(%d) scc<=(%d)\n", loval, scc);
	if(sel == 2)
		sprintf(buff, "S107<=(%d) scc<=(%d)\n", hival, scc);
	if(sel == 3)
		sprintf(buff, "S106<=(%d) S107<=(%d) scc<=(%d)\n", loval, hival, scc);
	
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintM0WithScc(int cuid, int wf, int pc, int val, int scc)
{
	pthread_mutex_lock(&lock);
	char buff[MAX_STR];
	int idx = findInstrIndex(cuid, wf, pc);
	sprintf(buff, "S124<=(%d) scc<=(%d)\n", val, scc);
	strcat(objects[cuid][wf][idx].buff, buff);
	pthread_mutex_unlock(&lock);
}

void PrintEndLine(int cuid, int wf, int pc)
{
	pthread_mutex_lock(&lock);
	int idx = findInstrIndex(cuid, wf, pc);
	strcat(objects[cuid][wf][idx].buff, "\n");
	pthread_mutex_unlock(&lock);
}

/************************************************************************/
/*               Region: Code for debugging purposes                    */
/************************************************************************/

#ifdef __DEBUG_TRACEMON__

int main(int argc, char *argv[])
{
	InitializeTraceMon(0);
	
	AddInstruction(0, 1, 1, 1, 0xD18C0009, 0x000E0001, 10);
	//AddInstruction(0, 2, 2, 200);
	AddInstruction(0, 1, 3, 0, 0x118C0009, 0x300E0001, 20);
	
	//PrintAndDeleteAll(0, 2);
	
	//AddInstruction(0, 1, 4, 400);
	PrintAndDelete(0, 1, 3);
	PrintAndDelete(0, 1, 1);
	//AddInstruction(0, 1, 5, 500);
	//PrintAndDelete(0, 1, 4);
	//PrintAndDeleteAll(0, 1);
	
	return 0;
}

#endif
