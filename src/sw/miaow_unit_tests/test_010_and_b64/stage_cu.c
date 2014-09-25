void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0x87810102);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x1);
   Xil_Out32(0x5000200C, 0x6);
   Xil_Out32(0x50002010, 0x14);
   Xil_Out32(0x50002014, 0xA);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x2D);
   Xil_Out32(0x5000200C, 0x1A);
   Xil_Out32(0x50002010, 0x13);
   Xil_Out32(0x50002014, 0x20);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x24);
   Xil_Out32(0x5000200C, 0x23);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
