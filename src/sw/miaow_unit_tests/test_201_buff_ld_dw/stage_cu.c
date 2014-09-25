void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xB0040000);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBE8503FF);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0x00200000);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xB004000E);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0xC2048504);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0xA);
   Xil_Out32(0x5000200C, 0x24);
   Xil_Out32(0x50002010, 0xE);
   Xil_Out32(0x50002014, 0x2F);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x21);
   Xil_Out32(0x5000200C, 0x2B);
   Xil_Out32(0x50002010, 0x8);
   Xil_Out32(0x50002014, 0x18);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x0);
   Xil_Out32(0x5000200C, 0x14);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
