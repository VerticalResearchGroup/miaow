void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xB0000000);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xB0010034);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xB0020000);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xB0030000);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0x7E0802FF);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0x0000000D);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xB008001A);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xE8770031);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0x08000104);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x29);
   Xil_Out32(0x5000200C, 0x23);
   Xil_Out32(0x50002010, 0x25);
   Xil_Out32(0x50002014, 0x23);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x1E);
   Xil_Out32(0x5000200C, 0x20);
   Xil_Out32(0x50002010, 0xC);
   Xil_Out32(0x50002014, 0x2);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x20);
   Xil_Out32(0x5000200C, 0x1E);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
