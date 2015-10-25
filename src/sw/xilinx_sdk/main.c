/*
 * Copyright (c) 2015, Ziliang Guo
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * * Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * * Neither the name of Wisconsin Robotics nor the
 *   names of its contributors may be used to endorse or promote products
 *   derived from this software without specific prior written permission.
 *   
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL WISCONSIN ROBOTICS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include "platform.h"
#include "xuartlite.h"
#include "xio.h"
#include "xparameters.h"

#define NEKO_CMD_ADDR XPAR_AXI_SLAVE_0_S00_AXI_BASEADDR
#define NEKO_BASE_LDS (NEKO_CMD_ADDR + 16)
#define NEKO_INSTR_ADDR (NEKO_CMD_ADDR + 28)
#define NEKO_INSTR_VALUE (NEKO_CMD_ADDR + 32)
#define NEKO_GPR_CMD (NEKO_CMD_ADDR + 40)
#define NEKO_SGRP_ADDR (NEKO_CMD_ADDR + 44)
#define NEKO_SGRP_QUAD_0 (NEKO_CMD_ADDR + 48)
#define NEKO_SGRP_QUAD_1 (NEKO_CMD_ADDR + 52)
#define NEKO_SGRP_QUAD_2 (NEKO_CMD_ADDR + 56)
#define NEKO_SGRP_QUAD_3 (NEKO_CMD_ADDR + 60)

#define NEKO_MEM_OP (NEKO_CMD_ADDR + 128)
#define NEKO_MEM_RD_DATA (NEKO_CMD_ADDR + 132) // Address for data to be read from MIAOW and written to memory
#define NEKO_MEM_ADDR (NEKO_CMD_ADDR + 136)
#define NEKO_MEM_WR_DATA (NEKO_CMD_ADDR + 192) // Address for writing data to MIAOW
#define NEKO_MEM_WR_EN (NEKO_CMD_ADDR + 196)
#define NEKO_MEM_ACK (NEKO_CMD_ADDR + 200)
#define NEKO_MEM_DONE (NEKO_CMD_ADDR + 204)

#define NEKO_CYCLE_COUNTER (NEKO_CMD_ADDR + 192)
#define NEKO_CURRENT_INST_ADDR (NEKO_CMD_ADDR + 196)

#define MEM_WR_ACK_WAIT 1
#define MEM_WR_RDY_WAIT 2
#define MEM_WR_LSU_WAIT 3
#define MEM_RD_ACK_WAIT 4
#define MEM_RD_RDY_WAIT 5
#define MEM_RD_LSU_WAIT 6

#define IDLE_STATE 0
#define LD_INSTR_STATE 1

#define RESET_INSTR_CNT 2
#define EXEC_KERNEL_STATE 3
#define CHECK_EXEC_STATUS 4
#define READ_PC_CNT 5

#define LD_MEM_DATA 6
#define RD_MEM_DATA 7
#define RESET_MEM_CNT 8
#define MEM_CNT_INC 9

#define MEM_WR_ADDR_OUT 20
#define KERNEL_DONE_OUT 50

XUartLite uartLite;
unsigned char sendBuffer[6];
u8 receiveBuffer[4];

int main()
{
	int status;
	u32 readData;
	unsigned int bytesToRead = 1;
	unsigned int bytesRead;
	unsigned int bytesReadTotal = 0;
	u8 *receiveBufferPointer = receiveBuffer;
	unsigned char state = IDLE_STATE;
	int instrAddrCnt = 0;
	u32 serialData;
	u32 memAddrCnt = XPAR_MIG_7SERIES_0_BASEADDR;

    init_platform();

    status = XUartLite_Initialize(&uartLite, XPAR_AXI_UARTLITE_0_DEVICE_ID);
    if(status != XST_SUCCESS)
    	return -1;

    XIo_Out32(NEKO_BASE_LDS, XPAR_MIG_7SERIES_0_BASEADDR);

    while(1)
    {
    	if(state == EXEC_KERNEL_STATE)
    	{
    		readData = XIo_In32(NEKO_MEM_OP);
        if(readData == MEM_WR_ACK_WAIT || readData == MEM_RD_ACK_WAIT)
        {
          int nextValue = MEM_RD_RDY_WAIT;
          int address;
          //xil_printf("Memop: %d\r\n", readData);

          address = XIo_In32(NEKO_MEM_ADDR) + XPAR_MIG_7SERIES_0_BASEADDR;
          if(readData == MEM_WR_ACK_WAIT)
          {
            nextValue = MEM_WR_RDY_WAIT;
            sendBuffer[0] = MEM_WR_ADDR_OUT;
            XUartLite_Send(&uartLite, sendBuffer, 1);
            sendBuffer[0] = (serialData >> 24) & 0xFF;
            sendBuffer[1] = (serialData >> 16) & 0xFF;
            sendBuffer[2] = (serialData >> 8) & 0xFF;
            sendBuffer[3] = serialData & 0xFF;
            XUartLite_Send(&uartLite, sendBuffer, 4);
          }

          XIo_Out32(NEKO_MEM_ACK, 0);
          XIo_Out32(NEKO_MEM_ACK, 1);
          XIo_Out32(NEKO_MEM_ACK, 0);

          do {
            readData = XIo_In32(NEKO_MEM_OP);
          } while(readData != nextValue);

          if(nextValue == MEM_RD_RDY_WAIT)
          {
            readData = XIo_In32(address);
            XIo_Out32(NEKO_MEM_WR_DATA, readData);
            XIo_Out32(NEKO_MEM_WR_EN, 0);
            XIo_Out32(NEKO_MEM_WR_EN, 1);
            XIo_Out32(NEKO_MEM_WR_EN, 0);
            nextValue = MEM_RD_LSU_WAIT;
          }
          else
          {
            readData = XIo_In32(NEKO_MEM_RD_DATA);
            XIo_Out32(address, readData);
            nextValue = MEM_WR_LSU_WAIT;
          }

          XIo_Out32(NEKO_MEM_DONE, 0);
          XIo_Out32(NEKO_MEM_DONE, 1);
          XIo_Out32(NEKO_MEM_DONE, 0);

          /*
          do {
            readData = XIo_In32(NEKO_MEM_OP);
          } while(readData != 0 && readData != nextValue);
          */
        }

    		if(XIo_In32(NEKO_CMD_ADDR) == 1)
    		{
    			state = IDLE_STATE;
          sendBuffer[0] = KERNEL_DONE_OUT;
          XUartLite_Send(&uartLite, sendBuffer, 1);
    		}
    	}

    	bytesRead = XUartLite_Recv(&uartLite, receiveBufferPointer, bytesToRead);
    	if(!bytesRead)
    		continue;
    	bytesReadTotal += bytesRead;
    	if(bytesReadTotal != bytesToRead)
    	{
    		receiveBufferPointer = receiveBufferPointer + bytesRead;
    		continue;
    	}

    	receiveBufferPointer = receiveBuffer;

    	switch(state)
    	{
    	case LD_INSTR_STATE:
    		state = IDLE_STATE;
    		serialData = ((u32)receiveBuffer[3] & 0xFF) + (((u32)receiveBuffer[2] << 8) & 0xFF00) + (((u32)receiveBuffer[1] << 16) & 0xFF0000) + (((u32)receiveBuffer[0] << 24) & 0xFF000000);
    		sendBuffer[0] = (serialData >> 24) & 0xFF;
    		sendBuffer[1] = (serialData >> 16) & 0xFF;
    		sendBuffer[2] = (serialData >> 8) & 0xFF;
    		sendBuffer[3] = serialData & 0xFF;

    		XUartLite_Send(&uartLite, sendBuffer, 4);
    		XIo_Out32(NEKO_INSTR_ADDR, instrAddrCnt);
    		XIo_Out32(NEKO_INSTR_VALUE, serialData);
    		instrAddrCnt += 1;
    		bytesToRead = 1;
    		break;
    	case LD_MEM_DATA:
    		state = IDLE_STATE;
			serialData = ((u32)receiveBuffer[3] & 0xFF) + (((u32)receiveBuffer[2] << 8) & 0xFF00) + (((u32)receiveBuffer[1] << 16) & 0xFF0000) + (((u32)receiveBuffer[0] << 24) & 0xFF000000);
    		sendBuffer[0] = (serialData >> 24) & 0xFF;
    		sendBuffer[1] = (serialData >> 16) & 0xFF;
    		sendBuffer[2] = (serialData >> 8) & 0xFF;
    		sendBuffer[3] = serialData & 0xFF;
    		XUartLite_Send(&uartLite, sendBuffer, 4);
			XIo_Out32(memAddrCnt, serialData);
			memAddrCnt += 4;
			bytesToRead = 1;
    		break;
    	case RD_MEM_DATA:
    		state = IDLE_STATE;
    		serialData = ((u32)receiveBuffer[3] & 0xFF) + (((u32)receiveBuffer[2] << 8) & 0xFF00) + (((u32)receiveBuffer[1] << 16) & 0xFF0000) + (((u32)receiveBuffer[0] << 24) & 0xFF000000);
    		readData = XIo_In32(serialData);
    		sendBuffer[0] = (readData >> 24) & 0xFF;
    		sendBuffer[1] = (readData >> 16) & 0xFF;
    		sendBuffer[2] = (readData >> 8) & 0xFF;
    		sendBuffer[3] = readData & 0xFF;
    		XUartLite_Send(&uartLite, sendBuffer, 4);
    		bytesToRead = 1;
    		break;
    	default:

    		if(receiveBuffer[0] == LD_INSTR_STATE)
    		{
    			state = LD_INSTR_STATE;
    			bytesToRead = 4;
    			break;
    		}

    		if(receiveBuffer[0] == RESET_INSTR_CNT)
    		{
    			instrAddrCnt = 0;
    			break;
    		}

    		if(receiveBuffer[0] == EXEC_KERNEL_STATE)
    		{
    			XIo_Out32(NEKO_CMD_ADDR, 1);
    			state = EXEC_KERNEL_STATE;
    			break;
    		}

    		if(receiveBuffer[0] == CHECK_EXEC_STATUS)
    		{
    			sendBuffer[0] = 0;
    			if(state == EXEC_KERNEL_STATE)
    				sendBuffer[0] = 1;
        		XUartLite_Send(&uartLite, sendBuffer, 1);
    		}

    		if(receiveBuffer[0] == READ_PC_CNT)
    		{
    			readData = XIo_In32(NEKO_CYCLE_COUNTER);
    			sendBuffer[0] = (readData >> 24) & 0xFF;
    			sendBuffer[1] = (readData >> 16) & 0xFF;
    			sendBuffer[2] = (readData >> 8) & 0xFF;
    			sendBuffer[3] = readData & 0xFF;
    			XUartLite_Send(&uartLite, sendBuffer, 4);
    		}

    		if(receiveBuffer[0] == LD_MEM_DATA)
    		{
    			state = LD_MEM_DATA;
    			bytesToRead = 4;
    		}

    		if(receiveBuffer[0] == RD_MEM_DATA)
    		{
    			state = RD_MEM_DATA;
    			bytesToRead = 4;
    		}

    		if(receiveBuffer[0] == MEM_CNT_INC)
    		{
    			XIo_Out32(memAddrCnt, 0);
    			memAddrCnt += 4;
    		}

    		break;
    	}

    	bytesReadTotal = 0;
    }

    cleanup_platform();
    return 0;
}
