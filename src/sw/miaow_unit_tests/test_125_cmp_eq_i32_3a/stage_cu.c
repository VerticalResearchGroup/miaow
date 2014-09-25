void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xD1040007);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0x04060604);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x0);
   Xil_Out32(0x5000200C, 0x2E);
   Xil_Out32(0x50002010, 0x16);
   Xil_Out32(0x50002014, 0x1A);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x6);
   Xil_Out32(0x5000200C, 0x29);
   Xil_Out32(0x50002010, 0x2F);
   Xil_Out32(0x50002014, 0xB);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x15);
   Xil_Out32(0x5000200C, 0x1D);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
