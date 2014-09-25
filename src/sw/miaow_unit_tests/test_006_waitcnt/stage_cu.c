void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xBF8C0001);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBE820308);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBE810301);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xBE840303);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0xBE890306);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0xBE800308);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xBF810000);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xBE820300);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0xBE880304);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBE880301);
   Xil_Out32(0x50001004, 40);
   Xil_Out32(0x50001000, 0xBE820309);
   Xil_Out32(0x50001004, 44);
   Xil_Out32(0x50001000, 0xBE820300);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0xE);
   Xil_Out32(0x5000200C, 0x2B);
   Xil_Out32(0x50002010, 0x31);
   Xil_Out32(0x50002014, 0x11);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x24);
   Xil_Out32(0x5000200C, 0x21);
   Xil_Out32(0x50002010, 0x2);
   Xil_Out32(0x50002014, 0x12);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x19);
   Xil_Out32(0x5000200C, 0x1C);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
