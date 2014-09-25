#ifndef __WAVE_H__
#define __WAVE_H__

// comment in release code
//#define __DEBUG_WAVE__

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#ifndef __DEBUG_WAVE__
#include "acc_user.h" 
#include "vpi_user.h" 
#endif

#define MAX_WFS_IN_TEST 600

#define MAX_NUM_OF_CU 4
#define MAX_WF_IN_CU 40
#define MAX_THRD_IN_WF 64
#define NUM_OF_ELEMS 80

#define MAX_VREG 1024
#define MAX_SREG 512
#define MAX_LDS 65536

#define MAX_REGS_SET 20

#define CONFIG_LINE_LEN 250000

// info about each block of resource
typedef struct _listElement {
	int wgId;
	int base;
	int size;
	int free;
} ListElem;

typedef struct _regValue {
	int reg;
	int val;
} RegValue;

// resources for each wavefront
typedef struct _resources {
	int wgId;
	int wfId;
	int wfCnt;
	int numOfThrds;
	
	int vregCnt;
	int sregCnt;
	int ldsCnt;
	
	char *vregs[MAX_THRD_IN_WF];
	char *sregs;
	
	int pc;
} Resources;

// data of a wavefront
typedef struct _waveFront {
	int cuId;
	int wgId;
	int wfId;
	int wfTag;
	int wfCnt;
	int numOfThrds;
	
	int vregBase;
	int vregSize;
	int sregBase;
	int sregSize;
	int ldsBase;
	int ldsSize;
	
	int setVregs;
	RegValue vregs[MAX_THRD_IN_WF][MAX_REGS_SET];
	int setSregs;
	RegValue sregs[MAX_REGS_SET];
	
	int pc;
} Wavefront;

// data of a compute unit
typedef struct _computeUnit {
	int id;
	
	// wavefronts allocated on the CU
	Wavefront wfs[MAX_WF_IN_CU];
	int numOfWfs;

	// vreg blocs free or allocated
	ListElem vReg[NUM_OF_ELEMS];
	int numVReg;
	
	// sreg blocs free or allocated
	ListElem sReg[NUM_OF_ELEMS];
	int numSReg;
	
	// lds blocs free or allocated
	ListElem lds[NUM_OF_ELEMS];
	int numLds;
} ComputeUnit;

int Initialize(int num_of_cu, int iter);
int getTotalWavefronts();
int ScheduleWavefront();
void DescheduleWavefront(int cuid, int wfTag);
int getCuId();
//int getWgId();
//int getWfId();
int getWfTag();
int getWfNumThrds();
int getVregBase();
int getVregSize();
int getSregBase();
int getSregSize();
int getLdsBase();
int getLdsSize();
int getSetVregs();
int getVregKey(int index, int thrd);
int getVregValue(int index, int thrd);
int getSetSregs();
int getSregKey(int index);
int getSregValue(int index);
#ifndef __DEBUG_WAVE__
void setVregValue(int cuid, int thrd, int vreg, int bitnum, int value);
void setSregValue(int cuid, int sreg, int bitnum, int value);
#endif
int getPC();

#endif /* __WAVE_H__ */
