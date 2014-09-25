#ifndef MADD_H_
#define MADD_H_

#include <CL/cl.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <SDKCommon.hpp>
#include <SDKApplication.hpp>
#include <SDKCommandArgs.hpp>
#include <SDKFile.hpp>


namespace madd
{
    /**
    * MADD 
    * Class implements OpenCL Discrete Cosine Transform 
    * Derived from SDKSample base class
    */

    class MADD : public SDKSample
    {
        cl_uint                     seed;    /**< Seed value for random number generation */
        cl_double              setupTime;    /**< Time for setting up OpenCL */
        cl_double        totalKernelTime;    /**< Time for kernel execution */
        cl_double       totalProgramTime;    /**< Time for program execution */
        cl_double    referenceKernelTime;    /**< Time for reference implementation */
        cl_int                     width;    /**< Width of the input array */
        cl_int                    height;    /**< height of the input array */
        cl_int                  *input;    /**< Input array */
        cl_int                  *input2;    /**< Input array */
        cl_int                 *output;    /**< Output array */
        cl_uint               blockWidth;    /**< width of the blockSize */
        cl_uint                blockSize;    /**< size fo the block */
        cl_uint                  inverse;    /**< flag for inverse MADD */
        cl_float     *verificationOutput;    /**< Input array for reference implementation */
        cl_context               context;    /**< CL context */
        cl_device_id            *devices;    /**< CL device list */
        cl_mem               inputBuffer;    /**< CL memory buffer */
        cl_mem               input2Buffer;    /**< CL memory buffer */
        cl_mem              outputBuffer;    /**< CL memory buffer */
        cl_command_queue    commandQueue;    /**< CL command queue */
        cl_program               program;    /**< CL program  */
        cl_kernel                 kernel;    /**< CL kernel */
        cl_ulong    availableLocalMemory;
        cl_ulong       neededLocalMemory;
        int                   iterations;    /**< Number of iteration for kernel execution */
        streamsdk::SDKDeviceInfo deviceInfo;            /**< Structure to store device information*/
        streamsdk::KernelWorkGroupInfo kernelInfo;      /**< Structure to store kernel related info */

        public:
        /** 
         * Constructor 
         * Initialize member variables
         * @param name name of sample (string)
         */
        MADD(std::string name)
            : SDKSample(name)    {
                seed = 123;
                input = NULL;
                input2 = NULL;
                verificationOutput = NULL;
                width = 8;
                height = 8;
                blockWidth = 8;
                blockSize  = blockWidth * blockWidth;
                inverse = 0;
                setupTime = 0;
                totalKernelTime = 0;
                iterations  = 1;
            }

        /** 
         * Constructor 
         * Initialize member variables
         * @param name name of sample (const char*)
         */
        MADD(const char* name)
            : SDKSample(name)    {
                seed = 123;
                input = NULL;
                input2 = NULL;
                verificationOutput = NULL;
                width = 8;
                height = 8;
                blockWidth = 8;
                blockSize  = blockWidth * blockWidth;
                inverse = 0;
                setupTime = 0;
                totalKernelTime = 0;
                iterations = 1;
            }

        /**
         * Allocate and initialize host memory array with random values
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int setupMADD();

        /**
         * OpenCL related initialisations. 
         * Set up Context, Device list, Command Queue, Memory buffers
         * Build CL kernel program executable
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int setupCL();

        /**
         * Set values for kernels' arguments, enqueue calls to the kernels
         * on to the command queue, wait till end of kernel execution.
         * Get kernel start and end time if timing is enabled
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int runCLKernels();

        /**
         * Given the blockindices and localIndicies this 
         * function calculate the global index
         * @param blockIdx index of the block horizontally
         * @param blockIdy index of the block vertically
         * @param localidx index of the element relative to the block horizontally
         * @param localIdy index of the element relative to the block vertically
         * @param blockWidth width of each blcok which is 8 
         * @param globalWidth Width of the input matrix
         * @return ID in x dimension
         */
        cl_uint getIdx(cl_uint blockIdx, cl_uint blockIdy, cl_uint localIdx, cl_uint localIdy, cl_uint blockWidth, cl_uint globalWidth);

        /**
         * Override from SDKSample. Print sample stats.
         */
        void printStats();

        /**
         * Override from SDKSample. Initialize 
         * command line parser, add custom options
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int initialize();

        /**
         * Override from SDKSample, Generate binary image of given kernel 
         * and exit application
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int genBinaryImage();

        /**
         * Override from SDKSample, adjust width and height 
         * of execution domain, perform all sample setup
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int setup();

        /**
         * Override from SDKSample
         * Run OpenCL MADD
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int run();

        /**
         * Override from SDKSample
         * Cleanup memory allocations
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int cleanup();

        /**
         * Override from SDKSample
         * Verify against reference implementation
         * @return SDK_SUCCESS on success and SDK_FAILURE on failure
         */
        int verifyResults();
    };
} //namespace MADD

#endif

