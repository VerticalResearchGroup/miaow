#include "wave.h"

int NUM_OF_CU = 0;

ComputeUnit allCUs[MAX_NUM_OF_CU];
Wavefront lastSchldWavefront;

Resources toSchedule[MAX_WFS_IN_TEST];

Resources workgroups[MAX_WFS_IN_TEST];
int maxWorkgroup = 0;
int currWorkgroup = 0;

int maxToSch = -1;
int curToSch = 0;

int lastStartCU = -1;
int wg2cu[MAX_WFS_IN_TEST][2];

/************************************************************************/
/*         Region: Initializing test (and helper functions)             */
/************************************************************************/

// parse the config file
int readConfigFile(int fno)
{
	char fileName[40];
	sprintf(fileName, "kernel_%d/config_%d.txt", fno, fno);

	// check if file exists
	struct stat buffer;   
  	if (stat (fileName, &buffer) != 0) return 0;

	FILE* fp = fopen(fileName, "r");

	char inp[CONFIG_LINE_LEN];
	char *tok = NULL;
	int i;

	// reading and discarding first line
	char *fline = fgets(inp, CONFIG_LINE_LEN, fp);

	while(1) {
		char *result = fgets(inp, CONFIG_LINE_LEN, fp);
		if(result == NULL) break;

		maxToSch = maxToSch + 1;

		tok = strtok(inp, ";");
		toSchedule[maxToSch].wgId = atoi(tok);
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].wfId = atoi(tok);
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].wfCnt = atoi(tok);
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].numOfThrds = atoi(tok);
		
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].vregCnt = atoi(tok);
		if(toSchedule[maxToSch].vregCnt % 4 != 0) {
			toSchedule[maxToSch].vregCnt = 
				(toSchedule[maxToSch].vregCnt/4 + 1) * 4;
		}
		
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].sregCnt = atoi(tok);
		if(toSchedule[maxToSch].sregCnt % 8 != 0) {
			toSchedule[maxToSch].sregCnt = 
				(toSchedule[maxToSch].sregCnt/8 + 1) * 8;
		}
		
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].ldsCnt = atoi(tok);
		
		for(i=0; i<toSchedule[maxToSch].numOfThrds; i++) {
			tok = strtok(NULL, ";");
			toSchedule[maxToSch].vregs[i] = strdup(tok);
			assert(toSchedule[maxToSch].vregs[i][0] == 'V');
		}
		
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].sregs = strdup(tok);
		assert(toSchedule[maxToSch].sregs[0] == 'S');
		
		tok = strtok(NULL, ";");
		toSchedule[maxToSch].pc = atoi(tok);
	}

	fclose(fp);

	return 1;
}

void copyFile(char *src, char *dest)
{
	FILE* fp1 = fopen(src, "r");
	FILE* fp2 = fopen(dest, "w");
	char inp[CONFIG_LINE_LEN];

	while(1) {
		char *result = fgets(inp, CONFIG_LINE_LEN, fp1);
		if(result == NULL) break;
		fputs(inp, fp2);
	}

	fclose(fp1);
	fclose(fp2);
}

// Copy data and instr
void copyDataAndInstr(int fno)
{
	char fileName[40];

	sprintf(fileName, "kernel_%d/data_%d.mem", fno, fno);
	copyFile(fileName, "data.mem");

	sprintf(fileName, "kernel_%d/instr_%d.mem", fno, fno);
	copyFile(fileName, "instr.mem");
}

int lookupWorkgroup(int wgId) {
  int i;
  for(i =0; i <maxWorkgroup; i++){
    if(workgroups[i].wgId == wgId) return 1;
  }

  return 0;
}
// get workgroups
void updateWorkgroups(void) {
  // For each item in toSchedule, lookup if the workgroup id is known
  // if not, add new workgroup


  int i;
  for(i =0; i<maxToSch+1; i++){
    // we dont have this workgroup yet
    if(!lookupWorkgroup(toSchedule[i].wgId)){
      workgroups[maxWorkgroup] = toSchedule[i];
      maxWorkgroup++;
    }
  }
}

// initialize the system
int Initialize(int num_of_cu, int iter)
{
	int i;
	NUM_OF_CU = num_of_cu;
	assert(NUM_OF_CU <= MAX_NUM_OF_CU);

	maxToSch = -1;
	curToSch = 0;

	for(i = 0; i < MAX_WFS_IN_TEST; i++) {
		wg2cu[i][0] = -1;
		wg2cu[i][1] = -1;
	}

	for (i = 0; i < NUM_OF_CU ; i++ ) {
		allCUs[i].id = i;
		allCUs[i].numOfWfs = 0;
		
		// set all resources as free and size them
		allCUs[i].numVReg = 1;
		allCUs[i].vReg[0].base = 0;
		allCUs[i].vReg[0].size = MAX_VREG;
		allCUs[i].vReg[0].free = 1;
		
		allCUs[i].numSReg = 1;
		allCUs[i].sReg[0].base = 0;
		allCUs[i].sReg[0].size = MAX_SREG;
		allCUs[i].sReg[0].free = 1;
		
		allCUs[i].numLds = 1;
		allCUs[i].lds[0].base = 0;
		allCUs[i].lds[0].size = MAX_LDS;
		allCUs[i].lds[0].free = 1;
	}

	int ret = readConfigFile(iter);
	if (ret == 0) return 0;

    updateWorkgroups();
	copyDataAndInstr(iter);
	return 1;
}

/************************************************************************/
/*          Region: Scheduling wavefronts (and helper functions)        */
/************************************************************************/

// check if resource allocation possible in a given ListElem array
int checkInElementArray(ListElem *lst, int maxCnt, int reqCnt)
{
	int match = -1, i;
	
	for(i = 0; i < maxCnt; i++) {
		if(lst[i].free == 1) {
			if(lst[i].size >= reqCnt) {
				match = 1;
				break;
			}
		}
	}
	
	return match;
}

int checkInArrayOrPresence(ListElem *lst, int maxCnt, int reqCnt, int wgId)
{
	int i;
	
	for(i = 0; i < maxCnt; i++) {
		if(lst[i].free < 1 && lst[i].wgId == wgId) {
			return 1;
		}
	}

	return checkInElementArray(lst, maxCnt, reqCnt);
}

// checks if the CU can handle the resources required for the job
// returns 1 if it can, -1 if it cannot
int checkForResourceAvail(ComputeUnit cu, Resources res) 
{
	int match;
	
	// check for maximum wavefronts on CU
	if(cu.numOfWfs == MAX_WF_IN_CU) {
		return -1;
	}

	// check vreg avail
	match = checkInElementArray(cu.vReg, cu.numVReg, res.vregCnt);
	if(match == -1) return -1;
	
	// check sreg avail
	match = checkInElementArray(cu.sReg, cu.numSReg, res.sregCnt);
	if(match == -1) return -1;
	
	// check lds avail
	match = checkInArrayOrPresence(cu.lds, cu.numLds, res.ldsCnt, res.wgId);
	if(match == -1) return -1;
	
	return 1;
}

// allocate resource in a given ListElem array (currently using first fit allocation)
int allocateInElemArrAndWf(ListElem *lst, int maxCnt, int reqCnt, int *resBase, int *resSize, int wgId)
{
	int i, j;
	
	for(i = 0; i < maxCnt; i++) {
		if(lst[i].free == 1) {
			if(lst[i].size < reqCnt) {
				continue;
			}
			else if(lst[i].size == reqCnt) {
				// nothing to do, just allocate
			}
			else if(lst[i].size > reqCnt) {
				// move the rest of the array by one index
				for(j = maxCnt; j > i; j--) {
					lst[j+1] = lst[j];
				}
				
				// split into 2 blocks
				lst[i+1].base = lst[i].base + reqCnt;
				lst[i+1].size = lst[i].size - reqCnt;
				lst[i+1].free = 1;
				
				lst[i].size = reqCnt;
				maxCnt = maxCnt + 1;
			}
			
			lst[i].free = 0;
			lst[i].wgId = wgId;
			*resBase = lst[i].base;
			*resSize = reqCnt;
			break;
		}
	}
	
	// assert that alloc has been found
	assert(i <= maxCnt);
	
	return maxCnt;
}

int checkIfNotAllocate(ListElem *lst, int maxCnt, int reqCnt, int *resBase, int *resSize, int wgId) {

	int i;
	
	for(i = 0; i < maxCnt; i++) {
		if(lst[i].free < 1 && lst[i].wgId == wgId) {
			*resBase = lst[i].base;
			*resSize = reqCnt;
			lst[i].free--;
			return maxCnt;
		}
	}

	return allocateInElemArrAndWf(lst, maxCnt, reqCnt, resBase, resSize, wgId);
}

// parse string of reg values and form RegValues
int fillRegValues(RegValue *regvals, char *regstr, int base)
{
	int i = 0;
	char *tok;
	
	//printf("%s\n", regstr);

	tok = strtok(regstr, ":");
	tok = strtok(NULL, "=");
	
	for(i=0; (i < MAX_REGS_SET) && (tok != NULL); i++) {
		regvals[i].reg = base + atoi(tok);
		tok = strtok(NULL, ",");
		assert(tok != NULL);
		regvals[i].val = atoi(tok);
		tok = strtok(NULL, "=");
	}
	
	// make sure that all reg values were read
	assert(tok == NULL);
	
	return i;
}

// allocates and adds a wavefront to a CU and returns it
Wavefront formAndAddWaveFrontOnCU(int cuId, Resources res)
{
	int i;
	Wavefront wf;
	
	// set already known info
	wf.cuId = cuId;
	wf.wgId = res.wgId;
	wf.wfId = res.wfId;
	wf.wfCnt = res.wfCnt;
	wf.wfTag = (res.wgId * 16) + res.wfId;
	wf.numOfThrds = res.numOfThrds;
	
	ComputeUnit cu = allCUs[cuId];

	// allocate vreg
	cu.numVReg = allocateInElemArrAndWf(cu.vReg, cu.numVReg, res.vregCnt, &(wf.vregBase), &(wf.vregSize), res.wgId);
	
	// allocate sreg
	cu.numSReg = allocateInElemArrAndWf(cu.sReg, cu.numSReg, res.sregCnt, &(wf.sregBase), &(wf.sregSize), res.wgId);
	
	// allocate lds
	cu.numLds = checkIfNotAllocate(cu.lds, cu.numLds, res.ldsCnt, &(wf.ldsBase), &(wf.ldsSize), res.wgId);

	
	// get set vreg values
	for(i=0; i<wf.numOfThrds; i++) {
		wf.setVregs = fillRegValues(wf.vregs[i], res.vregs[i], wf.vregBase);
	}
	
	// get set sreg values
	wf.setSregs = fillRegValues(wf.sregs, res.sregs, wf.sregBase);
	
	// set pc of the wavefront
	wf.pc = res.pc;

	// add wavefront to the CU
	cu.wfs[cu.numOfWfs] = wf;
	cu.numOfWfs = cu.numOfWfs + 1;
	allCUs[cuId] = cu;

	return wf;
}

int checkIfWavegroupSch(int wgId)
{
	int i;

	for(i = 0; i < MAX_WFS_IN_TEST; i++) {
		if(wg2cu[i][0] == wgId) {
			return wg2cu[i][1];
		}
	}

	return -1;
}

// called from the top level module to allocate a wavefront
int ScheduleWavefront()
{
	if(curToSch > maxToSch) {
		return -1;
	}

	int i, j;
	Resources res = toSchedule[curToSch]; // get amount of resource needed for new wavefront

	int cu = checkIfWavegroupSch(res.wgId);

	if(cu != -1) {
		int ret = checkForResourceAvail(allCUs[i], res);
		
		if(ret == 1) {
			// allocate on that CU and return the wavefront	
			Wavefront wf = formAndAddWaveFrontOnCU(i, res);
			lastSchldWavefront = wf;
			
			curToSch = curToSch + 1;
			return 1;
		}
		//else {
		//	fprintf(stderr, "Error scheduling wavegroup: %d\n", res.wgId);
		//	exit(-1);
		//}
	}
	else {
		lastStartCU = (lastStartCU + 1) % NUM_OF_CU;
		
		for(j = 0; j < NUM_OF_CU; j++) {
			i = (lastStartCU + j) % NUM_OF_CU;
			// check if there is a CU which can accomodate
			int ret = checkForResourceAvail(allCUs[i], res);
			
			if(ret == 1) {
				// allocate on that CU and return the wavefront
				Wavefront wf = formAndAddWaveFrontOnCU(i, res);
				lastSchldWavefront = wf;
				
				wg2cu[curToSch][0] = res.wgId;
				wg2cu[curToSch][1] = i;

				curToSch = curToSch + 1;
				return 1;
			}
		}
	}

	// there are wavefronts to be scheduled
	// but cannot be scheduled now
	Wavefront wf;
	wf.cuId = -1;
	wf.wfId = -1;
	lastSchldWavefront = wf;
	return -2;
}

/************************************************************************/
/*        Region: Descheduling wavefronts (and helper functions)        */
/************************************************************************/

// free a resource on desheduling
void releaseFromElemArray(ListElem *lst, int maxCnt, int resBase)
{
	int i;
	
	for(i = 0; i < maxCnt; i++) {
		if(lst[i].base == resBase) {
			lst[i].free++;
			break;
		}
	}
	
	// assert that entry was found
	assert(i <= maxCnt);
}

// descheduling when a wavefront is done processing
void DescheduleWavefront(int cuid, int wfTag)
{
	int i;
	Wavefront wf;
	
	// search for wavefront entry in CU
	for(i = 0; i < allCUs[cuid].numOfWfs; i++) {
		if(allCUs[cuid].wfs[i].wfTag == wfTag) {
			wf = allCUs[cuid].wfs[i];
			break;
		}
	}
	
	// confirm that the wavefront was found
	assert(i < allCUs[cuid].numOfWfs);
	
	// delete that entry of wavefront from the list
	for(; i < allCUs[cuid].numOfWfs - 1; i++) {
		allCUs[cuid].wfs[i] = allCUs[cuid].wfs[i+1];
	}
	
	allCUs[cuid].numOfWfs = allCUs[cuid].numOfWfs - 1;
	
	// free the block of vregs allocated
	releaseFromElemArray(allCUs[cuid].vReg, allCUs[cuid].numVReg, wf.vregBase);
	
	// free the block of sregs allocated
	releaseFromElemArray(allCUs[cuid].sReg, allCUs[cuid].numSReg, wf.sregBase);
	
	// free the block of lds allocated
	releaseFromElemArray(allCUs[cuid].lds, allCUs[cuid].numLds, wf.ldsBase);
}

/************************************************************************/
/*       Region: Get functions to access general config info            */
/************************************************************************/

int getTotalWavefronts()
{
	return (maxToSch + 1);
}


/************************************************************************/
/*       Region: Get functions to for the hardaware dispatcher          */
/************************************************************************/

#define VREG_ALLOC_UNIT 4
#define SREG_ALLOC_UNIT 8
#define LDS_ALLOC_UNIT 64

int checkWgAvailable(void){
  return (currWorkgroup<maxWorkgroup)? 1:0;
}

void prepareNextWg(void){
  currWorkgroup++;
}

int hardDisGetWgId()
{
  return workgroups[currWorkgroup].wgId;
}

int hardDisGetWfCnt()
{
  return workgroups[currWorkgroup].wfCnt;
}

int hardDisGetWfNumThrds()
{
  return workgroups[currWorkgroup].numOfThrds;
}

int hardDisGetVregSize()
{
  return (workgroups[currWorkgroup].vregCnt/VREG_ALLOC_UNIT)*
    workgroups[currWorkgroup].wfCnt;
}

int hardDisGetVregSizePerWf()
{
  return workgroups[currWorkgroup].vregCnt/VREG_ALLOC_UNIT;
}

int hardDisGetSregSize()
{
  return (workgroups[currWorkgroup].sregCnt/SREG_ALLOC_UNIT)*
    workgroups[currWorkgroup].wfCnt;
    
}

int hardDisGetSregSizePerWf()
{
  return workgroups[currWorkgroup].sregCnt/SREG_ALLOC_UNIT;
}

int hardDisGetLdsSize()
{
  return workgroups[currWorkgroup].ldsCnt/LDS_ALLOC_UNIT;
}

int hardDisGetGdsSize() {
  return 0;
}


int hardDisGetPc(){
  return workgroups[currWorkgroup].pc;
}


/************************************************************************/
/*       Region: Get functions to access the scheduled wavefront        */
/************************************************************************/

int getCuId()
{
	return lastSchldWavefront.cuId;
}

/*
int getWgId()
{
	return lastSchldWavefront.wgId;
}

int getWfId()
{
	return lastSchldWavefront.wfId;
}
*/

int getWfTag()
{
	return lastSchldWavefront.wfTag;
}

int getWfCnt()
{
	return lastSchldWavefront.wfCnt;
}

int getWfNumThrds()
{
	return lastSchldWavefront.numOfThrds;
}

int getVregBase()
{
	return lastSchldWavefront.vregBase;
}

int getVregSize()
{
	return lastSchldWavefront.vregSize;
}

int getSregBase()
{
	return lastSchldWavefront.sregBase;
}

int getSregSize()
{
	return lastSchldWavefront.sregSize;
}

int getLdsBase()
{
	return lastSchldWavefront.ldsBase;
}

int getLdsSize()
{
	return lastSchldWavefront.ldsSize;
}

/********************************/
// Reading of set vreg
/********************************/

int getSetVregs()
{
	return lastSchldWavefront.setVregs;
}

int getVregKey(int index, int thrd)
{
	if((index < lastSchldWavefront.setVregs) && (thrd < lastSchldWavefront.numOfThrds)) {
		return lastSchldWavefront.vregs[thrd][index].reg;
	}
	else {
		return -1;
	}
}

int getVregValue(int index, int thrd)
{
	if((index < lastSchldWavefront.setVregs) && (thrd < lastSchldWavefront.numOfThrds)) {
		return lastSchldWavefront.vregs[thrd][index].val;
	}
	else {
		return -1;
	}
}

/********************************/

/********************************/
// Reading of set sreg
/********************************/

int getSetSregs()
{
	return lastSchldWavefront.setSregs;
}

int getSregKey(int index)
{
	if(index < lastSchldWavefront.setSregs) {
		return lastSchldWavefront.sregs[index].reg;
	}
	else {
		return -1;
	}
}

int getSregValue(int index)
{
	if(index < lastSchldWavefront.setSregs) {
		return lastSchldWavefront.sregs[index].val;
	}
	else {
		return -1;
	}
}

#ifndef __DEBUG_WAVE__
/********************************/
// Setting of set vreg
/********************************/

void setVregValue(int cuid, int thrd, int vreg, int bitnum, int value)
{
	vpiHandle h1;
	char str[80];
	int banknum;
	int wordnum;

	//Vgpr is organized as 4 banks
	banknum = vreg % 4;
	wordnum = vreg / 4;

	sprintf(str, "gpu_tb.DUT[%d].vgpr0.reg_file.page[%d].bank%d.word[%d].bits[%d].flop_0.state", cuid, thrd, banknum, wordnum, bitnum);
	h1 = vpi_handle_by_name (str, NULL); 

	struct t_vpi_value argval;

	argval.format = vpiIntVal;
	argval.value.integer = value;
	vpi_put_value(h1, &argval, NULL, vpiNoDelay);
}

/********************************/
// Setting of set sreg
/********************************/

void setSregValue(int cuid, int sreg, int bitnum, int value)
{
	vpiHandle h1;
	char str[80];
	int banknum;
	int wordnum;

	//Sgpr is organized as 4 banks
	banknum = sreg % 4;
	wordnum = sreg / 4;

	sprintf(str, "gpu_tb.DUT[%d].sgpr0.sgpr_reg_file.bank%d.word[%d].bits[%d].flop_0.state", cuid, banknum, wordnum, bitnum);
	h1 = vpi_handle_by_name (str, NULL); 

	struct t_vpi_value argval;

	argval.format = vpiIntVal;
	argval.value.integer = value;
	vpi_put_value(h1, &argval, NULL, vpiNoDelay);
}

/********************************/
#endif

int getPC()
{
	return lastSchldWavefront.pc;
}

/************************************************************************/
/*               Region: Code for debugging purposes                    */
/************************************************************************/

// set at the beginning of the file
#ifdef __DEBUG_WAVE__

void printRegVals(RegValue *regvs, int size)
{
	int i;
	
	printf("\t\tSetRegs = %d : ", size);
	for(i=0; i < size; i++) {
		printf("%d = %d, ", regvs[i].reg, regvs[i].val);
	}
	printf("\n");
}

void printWavefront(Wavefront wf)
{
	int i;
	
	printf("\n");
	printf("WFID: %d : %d : %d -> %d threads\n", wf.cuId, wf.wgId , wf.wfId, wf.numOfThrds);
	printf("\tVREG: %d : %d\n", wf.vregBase, wf.vregSize);
	printf("\tSREG: %d : %d\n", wf.sregBase, wf.sregSize);
	printf("\tLDS : %d : %d\n", wf.ldsBase, wf.ldsSize);
	printf("\tVRegs: \n");
	for(i=0; i<wf.numOfThrds; i++) {
		printRegVals(wf.vregs[i], wf.setVregs);
	}
	printf("\tSRegs: \n");
	printRegVals(wf.sregs, wf.setSregs);
	printf("\tPC  : %d\n", wf.pc);
	printf("\n");
}

void printListElem(ListElem ls)
{
	printf("\t%d : %d : %d\n", ls.base, ls.size, ls.free);
}

void printCU(ComputeUnit cu)
{
	int i;
	
	printf("---------------------------------\n");
	printf("CUId: %d\n", cu.id);
	
	for(i = 0; i < cu.numOfWfs; i++) {
		printWavefront(cu.wfs[i]);
	}

	printf("VREGS:\n");
	for(i= 0; i < cu.numVReg; i++) {
		printListElem(cu.vReg[i]);
	}

	printf("SREGS:\n");
	for(i= 0; i < cu.numSReg; i++) {
		printListElem(cu.sReg[i]);
	}

	printf("LDS:\n");
	for(i= 0; i < cu.numLds; i++) {
		printListElem(cu.lds[i]);
	}

	printf("---------------------------------\n");
}

int main()
{
	int i, j;
	
	Initialize(1, 0);
	
	for(i = 0; i <= maxToSch; i++) {
		printf("%d, %d, %d, %d, %d, ", toSchedule[i].wgId, toSchedule[i].numOfThrds, 
				toSchedule[i].vregCnt, toSchedule[i].sregCnt, 
				toSchedule[i].ldsCnt);
		for(j = 0; j < toSchedule[i].numOfThrds; j++) printf("%s, ", toSchedule[i].vregs[j]);
		printf("%s, %d\n", toSchedule[i].sregs, toSchedule[i].pc);
	}

	int ret;
	
	ret = ScheduleWavefront();
	assert(ret == 1);
	//printCU(allCUs[0]);

	ret = ScheduleWavefront();
	printf("RET: %d\n", ret);
	assert(ret == 1);
	printCU(allCUs[0]);

	DescheduleWavefront(0, 17);
	//printCU(allCUs[0]);

	DescheduleWavefront(0, 18);
	//printCU(allCUs[1]);

	return 0;
}

/************************************************************************/

#endif
