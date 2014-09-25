#include "ut.hpp"

using namespace madd;

int 
MADD::setupMADD()
{
    cl_uint inputSizeBytes;
    cl_uint input2SizeBytes;

    // allocate and init memory used by host 
    inputSizeBytes = width * height * sizeof(cl_int);
    input = (cl_int *) malloc(inputSizeBytes);
    CHECK_ALLOCATION(input, "Failed to allocate host memory. (input)");

    // allocate and init memory used by host 
    input2SizeBytes = width * height * sizeof(cl_int);
    input2 = (cl_int *) malloc(input2SizeBytes);
    CHECK_ALLOCATION(input2, "Failed to allocate host memory. (input2)");

    cl_uint outputSizeBytes =  width * height * sizeof(cl_int);
    output = (cl_int *)malloc(outputSizeBytes);
    CHECK_ALLOCATION(output, "Failed to allocate host memory. (output)");

    // random initialisation of input
    sampleCommon->fillRandom<cl_int>(input, width, height, 0, 255);
    sampleCommon->fillRandom<cl_int>(input2, width, height, 0, 255);

    // Unless quiet mode has been enabled, print the INPUT array.

    if(!quiet)
    {
        sampleCommon->printArray<cl_int>(
            "Input1",
            input,
            width,
            1);

        sampleCommon->printArray<cl_int>(
            "Input2",
            input,
            width,
            1);
    }

    return SDK_SUCCESS;
}

int 
MADD::genBinaryImage()
{
    streamsdk::bifData binaryData;
    binaryData.kernelName = std::string("MADD_Kernels.cl");
    binaryData.flagsStr = std::string("");
    if(isComplierFlagsSpecified())
        binaryData.flagsFileName = std::string(flags.c_str());
    binaryData.binaryName = std::string(dumpBinary.c_str());
    int status = sampleCommon->generateBinaryImage(binaryData);
    return status;
}


int
MADD::setupCL(void)
{
    cl_int status = 0;
    cl_device_type dType;
    
    if(deviceType.compare("cpu") == 0)
    {
        dType = CL_DEVICE_TYPE_CPU;
    }
    else //deviceType = "gpu" 
    {
        dType = CL_DEVICE_TYPE_GPU;
        if(isThereGPU() == false)
        {
            std::cout << "GPU not found. Falling back to CPU device" << std::endl;
            dType = CL_DEVICE_TYPE_CPU;
        }
    }

    /*
     * Have a look at the available platforms and pick either
     * the AMD one if available or a reasonable default.
     */
    cl_platform_id platform = NULL;
    int retValue = sampleCommon->getPlatform(platform, platformId, isPlatformEnabled());
    CHECK_ERROR(retValue, SDK_SUCCESS, "sampleCommon::getPlatform() failed");

    // Display available devices.
    retValue = sampleCommon->displayDevices(platform, dType);
    CHECK_ERROR(retValue, SDK_SUCCESS, "sampleCommon::displayDevices() failed");


    // If we could find our platform, use it. Otherwise use just available platform.

    cl_context_properties cps[3] = 
    {
        CL_CONTEXT_PLATFORM, 
        (cl_context_properties)platform, 
        0
    };

    context = clCreateContextFromType(
                  cps,
                  dType,
                  NULL,
                  NULL,
                  &status);
    CHECK_OPENCL_ERROR( status, "clCreateContextFromType failed.");

    // getting device on which to run the sample
    status = sampleCommon->getDevices(context, &devices, deviceId, isDeviceIdEnabled());
    CHECK_ERROR(status, SDK_SUCCESS, "sampleCommon::getDevices() failed");

    {
        // The block is to move the declaration of prop closer to its use 
        cl_command_queue_properties prop = 0;
        commandQueue = clCreateCommandQueue(
                context, 
                devices[deviceId], 
                prop, 
                &status);
        CHECK_OPENCL_ERROR( status, "clCreateCommandQueue failed.");
    }

    //Set device info of given cl_device_id
    retValue = deviceInfo.setDeviceInfo(devices[deviceId]);
    CHECK_ERROR(retValue, SDK_SUCCESS, "SDKDeviceInfo::setDeviceInfo() failed");

    inputBuffer = clCreateBuffer(
                      context, 
                      CL_MEM_READ_ONLY,
                      sizeof(cl_int) * width * height,
                      NULL, 
                      &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (inputBuffer)");

    input2Buffer = clCreateBuffer(
                      context, 
                      CL_MEM_READ_ONLY,
                      sizeof(cl_int) * width * height,
                      NULL, 
                      &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (input2Buffer)");

    outputBuffer = clCreateBuffer(
                      context, 
                      CL_MEM_WRITE_ONLY,
                      sizeof(cl_int) * width * height,
                      NULL, 
                      &status);
    CHECK_OPENCL_ERROR(status, "clCreateBuffer failed. (outputBuffer)");

    // create a CL program using the kernel source 
    streamsdk::buildProgramData buildData;
    buildData.kernelName = std::string("MADD_Kernels.cl");
    buildData.devices = devices;
    buildData.deviceId = deviceId;
    buildData.flagsStr = std::string("");
    if(isLoadBinaryEnabled())
        buildData.binaryName = std::string(loadBinary.c_str());

    if(isComplierFlagsSpecified())
        buildData.flagsFileName = std::string(flags.c_str());

    retValue = sampleCommon->buildOpenCLProgram(program, context, buildData);
    CHECK_ERROR(retValue, SDK_SUCCESS, "sampleCommon::buildOpenCLProgram() failed");

    // get a kernel object handle for a kernel with the given name
    kernel = clCreateKernel(program, "MADD", &status);
    CHECK_OPENCL_ERROR(status, "clCreateKernel failed.");

    return SDK_SUCCESS;
}


int 
MADD::runCLKernels(void)
{
    cl_int   status;

    size_t globalThreads[2] = {width, height};
    size_t localThreads[2] = {blockWidth, blockWidth};

    status =  kernelInfo.setKernelWorkGroupInfo(kernel,devices[deviceId]);
    CHECK_ERROR(status, SDK_SUCCESS, "setKErnelWorkGroupInfo() failed");

    availableLocalMemory = deviceInfo.localMemSize - kernelInfo.localMemoryUsed;

    neededLocalMemory    = blockWidth * blockWidth* sizeof(cl_int); 

    if(neededLocalMemory > availableLocalMemory)
    {
        std::cout << "Unsupported: Insufficient local memory on device." << std::endl;
        return SDK_FAILURE;
    }

    if(localThreads[0]                 > deviceInfo.maxWorkItemSizes[0] ||
       localThreads[1]                 > deviceInfo.maxWorkItemSizes[1] ||
       localThreads[0] * localThreads[1] > deviceInfo.maxWorkGroupSize)
    {
        std::cout << "Unsupported: Device does not support requested number of work items."<<std::endl;
        return SDK_FAILURE;
    }

    if((cl_uint)(localThreads[0] * localThreads[1]) > kernelInfo.kernelWorkGroupSize)
    {
        if(!quiet)
        {
            std::cout << "Out of Resources!" << std::endl;
            std::cout << "Group Size required : {" 
                << localThreads[0] << "x" << localThreads[1] << "}" << std::endl;
            std::cout << "Max Group Size supported on the kernel : " 
                      << kernelInfo.kernelWorkGroupSize << std::endl;
            std::cout << "Exiting!\n";
        }
            return SDK_EXPECTED_FAILURE;
    }

    // Set input data
    cl_event writeEvt;
    status = clEnqueueWriteBuffer(
                commandQueue,
                inputBuffer,
                CL_FALSE,
                0,
                sizeof(cl_int) * width * height,
                input, 
                0,
                NULL,
                &writeEvt);
    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (inputBuffer)");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush failed.");

    status = sampleCommon->waitForEventAndRelease(&writeEvt);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(writeEvt) Failed");

    // Set input2 data
    cl_event writeEvt2;
    status = clEnqueueWriteBuffer(
                commandQueue,
                input2Buffer,
                CL_FALSE,
                0,
                sizeof(cl_int) * width * height,
                input2, 
                0,
                NULL,
                &writeEvt2);
    CHECK_OPENCL_ERROR(status, "clEnqueueWriteBuffer failed. (inputBuffer)");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush failed.");

    status = sampleCommon->waitForEventAndRelease(&writeEvt2);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(writeEvt2) Failed");
    // Set appropriate arguments to the kernel

    /** 
     * 1st argument to the kernel which stores the output of the MADD 
     */
    status = clSetKernelArg(
                    kernel, 
                    0, 
                    sizeof(cl_mem), 
                    (void *)&outputBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (outputBuffer)");

    /**
     * 2nd argument to the kernel , the input matrix 
     */
    status = clSetKernelArg(
                    kernel, 
                    1, 
                    sizeof(cl_mem), 
                    (void *)&inputBuffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (inputBuffer)");

    /**
     * 3rd argument to the kernel , the input2 matrix 
     */
    status = clSetKernelArg(
                    kernel, 
                    2, 
                    sizeof(cl_mem), 
                    (void *)&input2Buffer);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (input2Buffer)");

    /** 
     * 4th argument to the kernel , width of the input matrix 
     */
    status = clSetKernelArg(
                    kernel,
                    3,
                    sizeof(cl_uint),
                    (void *)&width);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (width)");

    /** 
     * 5th argument to the kernel , width of the block = 8 
     */
    status = clSetKernelArg(
                    kernel,
                    4,
                    sizeof(cl_uint),
                    (void *)&blockWidth);
    CHECK_OPENCL_ERROR(status, "clSetKernelArg failed. (blockWidth)");

    /**
     * Enqueue a kernel run call.
     */
    cl_event ndrEvt;
    status = clEnqueueNDRangeKernel(
                 commandQueue,
                 kernel,
                 2,
                 NULL,
                 globalThreads,
                 localThreads,
                 0,
                 NULL,
                 &ndrEvt);
    CHECK_OPENCL_ERROR(status, "clEnqueueNDRangeKernel failed.");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush failed.");

    status = sampleCommon->waitForEventAndRelease(&ndrEvt);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(ndrEvt) Failed");

    // Enqueue readBuffer
    cl_event readEvt;
    status = clEnqueueReadBuffer(
                commandQueue,
                outputBuffer,
                CL_FALSE,
                0,
                width * height * sizeof(cl_int),
                output,
                0,
                NULL,
                &readEvt);
    CHECK_OPENCL_ERROR(status, "clEnqueueReadBuffer failed.");

    status = clFlush(commandQueue);
    CHECK_OPENCL_ERROR(status, "clFlush failed.");

    status = sampleCommon->waitForEventAndRelease(&readEvt);
    CHECK_ERROR(status, SDK_SUCCESS, "WaitForEventAndRelease(readEvt) Failed");

    return SDK_SUCCESS;
}



cl_uint
MADD::getIdx(cl_uint blockIdx, cl_uint blockIdy, cl_uint localIdx, cl_uint localIdy, cl_uint blockWidth, cl_uint globalWidth)
{
    cl_uint globalIdx = blockIdx * blockWidth + localIdx;
    cl_uint globalIdy = blockIdy * blockWidth + localIdy;
    return (globalIdy * globalWidth  + globalIdx);
}



int MADD::initialize()
{
    // Call base class Initialize to get default configuration
    CHECK_ERROR(this->SDKSample::initialize(), SDK_SUCCESS, "OpenCL resource initilization failed");
    streamsdk::Option* width_option = new streamsdk::Option;
    CHECK_ALLOCATION(width_option, "Memory allocation error.\n");

    width_option->_sVersion = "x";
    width_option->_lVersion = "width";
    width_option->_description = "Width of the input matrix";
    width_option->_type = streamsdk::CA_ARG_INT;
    width_option->_value = &width;

    sampleArgs->AddOption(width_option);
    delete width_option;

    streamsdk::Option* height_option = new streamsdk::Option;
    CHECK_ALLOCATION(height_option, "Memory allocation error.\n");

    height_option->_sVersion = "y";
    height_option->_lVersion = "height";
    height_option->_description = "Height of the input matrix";
    height_option->_type = streamsdk::CA_ARG_INT;
    height_option->_value = &height;

    sampleArgs->AddOption(height_option);
    delete height_option;

    streamsdk::Option* num_iterations = new streamsdk::Option;
    CHECK_ALLOCATION(num_iterations, "Memory allocation error.\n");

    num_iterations->_sVersion = "i";
    num_iterations->_lVersion = "iterations";
    num_iterations->_description = "Number of iterations for kernel execution";
    num_iterations->_type = streamsdk::CA_ARG_INT;
    num_iterations->_value = &iterations;

    sampleArgs->AddOption(num_iterations);
    delete num_iterations;
    return SDK_SUCCESS;
}

int MADD::setup()
{
    // Make sure the width is a multiple of blockWidth 8 here
    if(width % blockWidth != 0)
        width = (width/blockWidth + 1)*blockWidth;

    // Make sure the height is a multiple of blockWidth 8 here
    if(height%blockWidth !=0)
        height = (height/blockWidth + 1) * blockWidth;
    CHECK_ERROR(setupMADD(), SDK_SUCCESS, "OpenCL setupMADD failed");
    int timer = sampleCommon->createTimer();
    sampleCommon->resetTimer(timer);
    sampleCommon->startTimer(timer);
    if(setupCL() != SDK_SUCCESS)
        return SDK_FAILURE;
    sampleCommon->stopTimer(timer);

    setupTime = (cl_double)sampleCommon->readTimer(timer);
    return SDK_SUCCESS;
}


int MADD::run()
{
    // Warm up
    for(int i = 0; i < 2 && iterations != 1; i++)
    {
        // Arguments are set and execution call is enqueued on command buffer
         if (runCLKernels() != SDK_SUCCESS)
            return SDK_FAILURE;
    }

    std::cout << "Executing kernel for " << iterations 
              << " iterations" << std::endl;
    std::cout << "-------------------------------------------" << std::endl;

    int timer = sampleCommon->createTimer();
    sampleCommon->resetTimer(timer);
    sampleCommon->startTimer(timer);   

    for(int i = 0; i < iterations; i++)
    {
        // Arguments are set and execution call is enqueued on command buffer
        if (runCLKernels() != SDK_SUCCESS)
            return SDK_FAILURE;
    }

    sampleCommon->stopTimer(timer);
    totalKernelTime = (double)(sampleCommon->readTimer(timer)) / iterations;

    if(!quiet) {
        sampleCommon->printArray<cl_int>("Output", output, width,1);
    }

    return SDK_SUCCESS;
}

void MADD::printStats()
{
    std::string strArray[4] = {"Width", "Height", "Time(sec)", "[Transfer+Kernel]Time(sec)"};
    std::string stats[4];

    totalTime = setupTime + totalKernelTime;

    stats[0]  = sampleCommon->toString(width    , std::dec);
    stats[1]  = sampleCommon->toString(height   , std::dec);
    stats[2]  = sampleCommon->toString(totalTime, std::dec);
    stats[3]  = sampleCommon->toString(totalKernelTime, std::dec);

    this->SDKSample::printStats(strArray, stats, 4);
}

int MADD::cleanup()
{
    // Releases OpenCL resources (Context, Memory etc.)
    cl_int status;

    status = clReleaseKernel(kernel);
    CHECK_OPENCL_ERROR(status, "clReleaseKernel failed.(kernel)");

    status = clReleaseProgram(program);
    CHECK_OPENCL_ERROR(status, "clReleaseProgram failed.(program)");

    status = clReleaseMemObject(inputBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.(inputBuffer)");

    status = clReleaseMemObject(outputBuffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.");

    status = clReleaseMemObject(input2Buffer);
    CHECK_OPENCL_ERROR(status, "clReleaseMemObject failed.(input2Buffer)");

    status = clReleaseCommandQueue(commandQueue);
     CHECK_OPENCL_ERROR(status, "clReleaseCommandQueue failed.(commandQueue)");

    status = clReleaseContext(context);
    CHECK_OPENCL_ERROR(status, "clReleaseContext failed.(context)");

    // release program resources (input memory etc.)
    FREE(input);
    FREE(input2);
    FREE(output);
    FREE(verificationOutput);
    FREE(devices);

    return SDK_SUCCESS;
}

int 
main(int argc, char * argv[])
{
    MADD clMADD("OpenCL MADD8x8");
    if(clMADD.initialize() != SDK_SUCCESS)
        return SDK_FAILURE;

    if(clMADD.parseCommandLine(argc, argv) != SDK_SUCCESS)
        return SDK_FAILURE;

    if(clMADD.isDumpBinaryEnabled())
    {
        return clMADD.genBinaryImage();
    }

    if(clMADD.setup() != SDK_SUCCESS)
        return SDK_FAILURE;

    if(clMADD.run() != SDK_SUCCESS)
        return SDK_FAILURE;

    if(clMADD.cleanup() != SDK_SUCCESS)
        return SDK_FAILURE;

    clMADD.printStats();

    return SDK_SUCCESS;
}

int MADD::verifyResults()
{

}
