void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xD2D20008);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0x04260A04);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x15);
   Xil_Out32(0x5000200C, 0x17);
   Xil_Out32(0x50002010, 0x16);
   Xil_Out32(0x50002014, 0x29);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x14);
   Xil_Out32(0x5000200C, 0x11);
   Xil_Out32(0x50002010, 0x1C);
   Xil_Out32(0x50002014, 0x5);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x1);
   Xil_Out32(0x5000200C, 0x21);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
