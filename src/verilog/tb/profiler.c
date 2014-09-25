#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#define MAX_NUM_OF_CU 4
#define MAX_WF_IN_CU 40
#define MAXQ_OCC 10
#define MAX_VEXEC 10

int cntOfSalu[MAX_NUM_OF_CU];
int cntOfValu[MAX_NUM_OF_CU];
int cntOfMem[MAX_NUM_OF_CU];

int numOfSalu[MAX_NUM_OF_CU];
int numOfValu[MAX_NUM_OF_CU];
int numOfMem[MAX_NUM_OF_CU];

int timeOfSalu[MAX_NUM_OF_CU];
int timeOfValu[MAX_NUM_OF_CU];
int timeOfMem[MAX_NUM_OF_CU];

int ctimeOfSalu[MAX_NUM_OF_CU];
int ctimeOfValu[MAX_NUM_OF_CU];
int ctimeOfMem[MAX_NUM_OF_CU];

int waveQ[MAX_NUM_OF_CU][MAX_WF_IN_CU];
int waveQProf[MAX_NUM_OF_CU][MAX_WF_IN_CU][MAXQ_OCC];

int valuQ[MAX_NUM_OF_CU][MAX_VEXEC];
int valuQProf[MAX_NUM_OF_CU][MAX_VEXEC][MAXQ_OCC];

// initializing the size of all wavefronts to 0
void InitializeProfiler(int cuid)
{
	int i;
	
	for(i = 0; i < MAX_NUM_OF_CU; i++) {
		cntOfSalu[i] = 0;
		cntOfValu[i] = 0;
		cntOfMem[i] = 0;

		numOfSalu[i] = 0;
		numOfValu[i] = 0;
		numOfMem[i] = 0;

		timeOfSalu[i] = 0;
		timeOfValu[i] = 0;
		timeOfMem[i] = 0;

		ctimeOfSalu[i] = 0;
		ctimeOfValu[i] = 0;
		ctimeOfMem[i] = 0;
	}
}

void StartSALUExec(int cuid, int time) {
	if(numOfSalu[cuid] == 0) timeOfSalu[cuid] = time;
	numOfSalu[cuid] = numOfSalu[cuid] + 1;
	cntOfSalu[cuid] = cntOfSalu[cuid] + 1;
}

void StartVALUExec(int cuid, int time) {
	if(numOfValu[cuid] == 0) timeOfValu[cuid] = time;
	numOfValu[cuid] = numOfValu[cuid] + 1;
	cntOfValu[cuid] = cntOfValu[cuid] + 1;
}

void StartMemExec(int cuid, int time) {
	if(numOfMem[cuid] == 0) timeOfMem[cuid] = time;
	numOfMem[cuid] = numOfMem[cuid] + 1;
	cntOfMem[cuid] = cntOfMem[cuid] + 1;
}

void WriteToFile(char *unit, int cuid, int time, int cnt) {
	FILE *fp;
	char fileName[50];
	char buff[50];
	
	sprintf(buff, "%d, %d\n", cnt, time);

	sprintf(fileName, "%s_%d.tim", unit, cuid);
	fp = fopen(fileName, "a");
	fprintf(fp, "%s", buff);
	fclose(fp);
}

void FinishSALUExec(int cuid, int time) {
	numOfSalu[cuid] = numOfSalu[cuid] - 1;
	assert(numOfSalu[cuid] > -1);

	if(numOfSalu[cuid] == 0) {
		ctimeOfSalu[cuid] += time - timeOfSalu[cuid];
		WriteToFile("salu", cuid, ctimeOfSalu[cuid], cntOfSalu[cuid]);
	}
}

void FinishVALUExec(int cuid, int time) {
	numOfValu[cuid] = numOfValu[cuid] - 1;
	assert(numOfValu[cuid] > -1);

	if(numOfValu[cuid] == 0) {
		ctimeOfValu[cuid] += time - timeOfValu[cuid];
		WriteToFile("valu", cuid, ctimeOfValu[cuid], cntOfValu[cuid]);
	}
}

void FinishMemExec(int cuid, int time) {
	numOfMem[cuid] = numOfMem[cuid] - 1;
	assert(numOfMem[cuid] > -1);

	if(numOfMem[cuid] == 0) {
		ctimeOfMem[cuid] += time - timeOfMem[cuid];
		WriteToFile("mem", cuid, ctimeOfMem[cuid], cntOfMem[cuid]);
	}
}

void WavepoolQAdd(int cuid, int qid) {
	waveQ[cuid][qid]++;
}

void WavepoolQRemove(int cuid, int qid) {
	waveQ[cuid][qid]--;
	assert(waveQ[cuid][qid] >= 0);
}

void WavepoolQReset(int cuid, int qid) {
	waveQ[cuid][qid] = 0;
}

void WavepoolQProfile(int cuid) {
	int i;

	for(i = 0; i < MAX_WF_IN_CU; i++) {
		waveQProf[cuid][i][waveQ[cuid][i]]++;
	}
}

void WavepoolQProfileOut(int cuid) {
	FILE *fp;
	char buff[5000], fileName[50];
	buff[0] = '\0';
	int i, j;

	for(i = 0; i < MAX_WF_IN_CU; i++) {
		for (j = 0; j < MAXQ_OCC; j++) {
			sprintf(buff, "%s%d,", buff, waveQProf[cuid][i][j]);
		}

		sprintf(buff, "%s|", buff);
	}
	
	sprintf(fileName, "waveq_%d.occ", cuid);
	fp = fopen(fileName, "a");
	fprintf(fp, "%s\n", buff);
	fclose(fp);
}

void ValuQAdd(int cuid, int sid) {
	valuQ[cuid][sid]++;
}

void ValuQRemove(int cuid, int sid) {
	valuQ[cuid][sid]--;
	assert(valuQ[cuid][sid] >= 0);
}

void ValuQProfile(int cuid) {
	int i;

	for(i = 0; i < MAX_VEXEC; i++) {
		valuQProf[cuid][i][valuQ[cuid][i]]++;
	}
}

void ValuQProfileOut(int cuid) {
	FILE *fp;
	char buff[5000], fileName[50];
	buff[0] = '\0';
	int i, j;

	for(i = 0; i < MAX_VEXEC; i++) {
		for (j = 0; j < MAXQ_OCC; j++) {
			sprintf(buff, "%s%d,", buff, valuQProf[cuid][i][j]);
		}

		sprintf(buff, "%s|", buff);
	}
	
	sprintf(fileName, "valuq_%d.occ", cuid);
	fp = fopen(fileName, "a");
	fprintf(fp, "%s\n", buff);
	fclose(fp);
}