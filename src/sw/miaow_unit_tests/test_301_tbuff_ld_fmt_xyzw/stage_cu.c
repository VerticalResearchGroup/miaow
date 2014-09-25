void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xB0100000);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xB011007C);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xB0120000);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xB0130000);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0x7E0602FF);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0x00000002);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xB008000C);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xE8731027);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0x08040703);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x31);
   Xil_Out32(0x5000200C, 0x1E);
   Xil_Out32(0x50002010, 0x2C);
   Xil_Out32(0x50002014, 0x1C);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x20);
   Xil_Out32(0x5000200C, 0x2);
   Xil_Out32(0x50002010, 0x2B);
   Xil_Out32(0x50002014, 0x23);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x7);
   Xil_Out32(0x5000200C, 0x1);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
