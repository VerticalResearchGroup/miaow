void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xBE822406);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x31);
   Xil_Out32(0x5000200C, 0x11);
   Xil_Out32(0x50002010, 0xD);
   Xil_Out32(0x50002014, 0x29);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x8);
   Xil_Out32(0x5000200C, 0x16);
   Xil_Out32(0x50002010, 0xF);
   Xil_Out32(0x50002014, 0x2B);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x4);
   Xil_Out32(0x5000200C, 0x22);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
