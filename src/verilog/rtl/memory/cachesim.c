// Somayeh Sardashti
// May 2009
// ECE/CS 552
// Cache Simulator
//
// Updated by Cherin Joseph
// April 2013
// Added support for pseudo random replacement

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>

//defines a cache way
typedef struct __Way {
	int valid;
	int dirty;
	int tag;
	int data;
//	int LRUCnt;
	struct timeval LRUTime;

} cacheWay;

//define a cache set
typedef struct __Set {
//	int LRU;
	cacheWay *ways;
} cacheSet;

//define a cache trace
typedef struct __Trace {
        int write;
        int read;
	int address;
	int data;
} cacheTrace;   

int associativity;
int cacheSize;
int blockSize;
int numSets;
cacheSet *cacheLines;

int wordSize;
int indexSize;
int tagSize;

int pseudo_random;

void setAddressBits(){
	//address = Tag&Index&Word
	wordSize = log2(blockSize);
	indexSize = log2(numSets);
	tagSize = log2(cacheSize) - indexSize - wordSize;
}

int getIndex (int address){
	//address = Tag&Index&Word
	int index = address % (numSets*blockSize);
	index = index / blockSize;
        return index;
}

int getTag (int address){
	//address = Tag&Index&Word
	int tag = address/(numSets*blockSize);
	return tag;
}

void updateLRUCnt(int index, int way){
/*	int i;
	for (i=0; i<associativity; i++){
		if (i != way)
			cacheLines[index].ways[i].LRUCnt--;
		else
			cacheLines[index].ways[i].LRUCnt++;
	}*/

	gettimeofday( &(cacheLines[index].ways[way].LRUTime), NULL);

}

int getLRU(int index){
	int i;
	struct timeval curTime;	
	gettimeofday( &curTime, NULL);
	double minTime = curTime.tv_sec + curTime.tv_usec + 1000;
	////printf ("minTime %f \n", minTime);

	int LRU;

	for (i=0; i<associativity; i++){
		double t = (cacheLines[index].ways[i].LRUTime).tv_sec + (cacheLines[index].ways[i].LRUTime).tv_usec;
		////printf ("way %d, time %f \n", i, t);
		if ( t < minTime ){
			LRU = i;
			minTime = (cacheLines[index].ways[i].LRUTime).tv_sec + (cacheLines[index].ways[i].LRUTime).tv_usec;
		}
	}

	////printf ("LRU %d \n", LRU);	
	return LRU;
}

int updatePseudoRandomState()
{
  static int victimWay = 0;
  //Toggle 1/0 for each access
  victimWay = (1 + victimWay) % associativity;
  return victimWay;
}

int runTrace (cacheTrace trace) 
{
	int index = getIndex (trace.address);
	int tag = getTag (trace.address);
	int data = trace.data;

	int i;
	int found = 0;

    int pseudoRandom_victimWay;
    int PR;

    if (pseudo_random)
    {
      pseudoRandom_victimWay = updatePseudoRandomState();
    }

	for (i=0; i<associativity; i++){

		if (cacheLines[index].ways[i].valid && (cacheLines[index].ways[i].tag == tag)){
			if (trace.write) {
				//printf ("Store Hit for Address %d \n", trace.address);
				updateLRUCnt(index, i);	
                cacheLines[index].ways[i].dirty = 1;

				found = 1;
				break;
			}

            if (trace.read) {
                //printf ("Load Hit for Address %d \n", trace.address);
				updateLRUCnt(index, i);	
				found = 1;
				break;
            }
		}
	}

	if (!found) {
		int LRU = getLRU(index);

		//Code section to fine a victim for Pseudo random replacement
		if(pseudo_random)
		{
        	for(i=0; i<associativity; i++) {
				if(0 == cacheLines[index].ways[i].valid) {
					PR = i;
					break;
				}
			}

			if(i == associativity) {
				PR = pseudoRandom_victimWay;
			}

			//FIXME
			//This is a hack to reuse below code without change
			//Better use a variable called victim and assign one of LRU or PR to it
			LRU = PR;
		}

		if (trace.write){
			if (cacheLines[index].ways[LRU].valid && (cacheLines[index].ways[LRU].dirty)) {
                //printf ("Store Miss for Address %d with a Dirty Eviction \n", trace.address);
				updateLRUCnt(index, LRU);
            }
			else {
                if (cacheLines[index].ways[LRU].valid){
                	//printf ("Store Miss for Address %d with Eviction \n", trace.address);
					updateLRUCnt(index, LRU);
				}
				else{
                    //printf ("Store Miss for Address %d \n", trace.address);
					updateLRUCnt(index, LRU);
				}
                        }
			cacheLines[index].ways[LRU].valid = 1;
			cacheLines[index].ways[LRU].dirty = 1;
			cacheLines[index].ways[LRU].tag = tag;
            cacheLines[index].ways[LRU].data = data;
		}                        

        else if (trace.read) {
            if (cacheLines[index].ways[LRU].valid && (cacheLines[index].ways[LRU].dirty)) {
                //printf ("Load Miss for Address %d with a Dirty Eviction \n", trace.address);
				updateLRUCnt(index, LRU);
            }
            else {
                if (cacheLines[index].ways[LRU].valid) {
                    //printf ("Load Miss for Address %d with Eviction \n", trace.address);
					updateLRUCnt(index, LRU);
                }
                else {
                    //printf ("Load Miss for Address %d \n", trace.address);
					updateLRUCnt(index, LRU);
                }
            }

            cacheLines[index].ways[LRU].valid = 1;
            cacheLines[index].ways[LRU].dirty = 0;
            cacheLines[index].ways[LRU].tag = tag;
            cacheLines[index].ways[LRU].data = data;                         
        }        
	}

	return found;
}

int RunTraceWrapper(int write, int read, int address, int data)
{
	cacheTrace trace;
	
	trace.write = write;
	trace.read = read;
	trace.address = address;
	trace.data = data;
	
	return runTrace(trace);
}

void Init_cache(int a, int c, int b)
{
	associativity = a;
	cacheSize = c;
	blockSize = b;

    pseudo_random = 1;
	numSets = cacheSize / (blockSize * associativity);

	cacheLines = malloc (numSets*sizeof(cacheSet));

	int i;
	for (i=0; i<numSets; i++) {
        	cacheLines[i].ways = malloc (associativity*sizeof(cacheWay));		
	}

	//initializing
	int j;
	cacheWay* ways;
	struct timeval curTime;
	gettimeofday(&curTime, NULL);

	double t = curTime.tv_sec;

	for (i=0; i<numSets; i++){
		for (j=0; j<associativity; j++){
        	cacheLines[i].ways[j].valid = 0;
            cacheLines[i].ways[j].dirty = 0;         
            cacheLines[i].ways[j].tag = 0;
            cacheLines[i].ways[j].data = 0;
            //cacheLines[i].ways[j].LRUCnt = 0;
			cacheLines[i].ways[j].LRUTime.tv_sec = curTime.tv_sec;			
		}
    }

	//set address bits
	setAddressBits();
}
