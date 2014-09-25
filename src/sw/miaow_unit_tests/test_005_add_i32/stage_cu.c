void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0x81010401);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0xB);
   Xil_Out32(0x5000200C, 0x22);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x17);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x25);
   Xil_Out32(0x5000200C, 0x1F);
   Xil_Out32(0x50002010, 0x29);
   Xil_Out32(0x50002014, 0x16);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x1D);
   Xil_Out32(0x5000200C, 0x24);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
