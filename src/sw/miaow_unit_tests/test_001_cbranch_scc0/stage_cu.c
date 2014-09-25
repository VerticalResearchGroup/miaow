void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xBF840004);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBE850304);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBE890306);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xBE850300);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0xBE890308);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0xBE830309);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xBF810000);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xBE840302);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0xBE870305);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBE830309);
   Xil_Out32(0x50001004, 40);
   Xil_Out32(0x50001000, 0xBE840301);
   Xil_Out32(0x50001004, 44);
   Xil_Out32(0x50001000, 0xBE800305);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x1A);
   Xil_Out32(0x5000200C, 0x17);
   Xil_Out32(0x50002010, 0x31);
   Xil_Out32(0x50002014, 0x8);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x7);
   Xil_Out32(0x5000200C, 0x24);
   Xil_Out32(0x50002010, 0x19);
   Xil_Out32(0x50002014, 0x23);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x24);
   Xil_Out32(0x5000200C, 0x1F);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
