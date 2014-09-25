/**
 * Given the blockindices and localIndicies this 
 * function calculate the global index
 * @param blockIdx index of the block horizontally
 * @param blockIdy index of the block vertically
 * @param localidx index of the element relative to the block horizontally
 * @param localIdy index of the element relative to the block vertically
 * @param blockWidth width of each blcok which is 8 
 * @param globalWidth Width of the input matrix
 */
uint
getIdx(uint blockIdx, uint blockIdy, uint localIdx, uint localIdy, uint blockWidth, uint globalWidth)
{
    uint globalIdx = blockIdx * blockWidth + localIdx;
    uint globalIdy = blockIdy * blockWidth + localIdy;

    return (globalIdy * globalWidth  + globalIdx);
}
/**
 * Perform Matrix Addition
 * @param output output of the MADD 
 * @param input  input array 
 * @param input2 input array
 * @param width  width of the input matrix
 * @param blockWidth width of each block, 8 here
 */

__kernel 
void MADD(__global int * output,
         __global int * input, 
         __global int * input2,
         const    uint    width,
         const    uint  blockWidth)
{
	/* get global indices of the element */
    uint globalIdx = get_global_id(0);
    uint globalIdy = get_global_id(1);
    uint idx = globalIdy * width + globalIdx;

    output[idx] = input[idx] + input2[idx];   
}

