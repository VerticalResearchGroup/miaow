void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xB0200000);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xB0210080);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xB0220000);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xB0230000);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0x7E0402FF);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0x0000001C);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xB003001F);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xE8242005);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0x03080602);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x11);
   Xil_Out32(0x5000200C, 0x25);
   Xil_Out32(0x50002010, 0x30);
   Xil_Out32(0x50002014, 0x7);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x6);
   Xil_Out32(0x5000200C, 0x11);
   Xil_Out32(0x50002010, 0xE);
   Xil_Out32(0x50002014, 0x6);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x12);
   Xil_Out32(0x5000200C, 0x2E);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
