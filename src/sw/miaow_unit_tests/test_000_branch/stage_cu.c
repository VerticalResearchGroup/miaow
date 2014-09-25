void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xBF820004);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBE810309);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBE820307);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xBE810309);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0xBE850301);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0xBE810303);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xBF810000);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xBE830301);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0xBE870304);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBE850304);
   Xil_Out32(0x50001004, 40);
   Xil_Out32(0x50001000, 0xBE800308);
   Xil_Out32(0x50001004, 44);
   Xil_Out32(0x50001000, 0xBE870306);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x0);
   Xil_Out32(0x5000200C, 0x3);
   Xil_Out32(0x50002010, 0x25);
   Xil_Out32(0x50002014, 0x27);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x2D);
   Xil_Out32(0x5000200C, 0x2F);
   Xil_Out32(0x50002010, 0x31);
   Xil_Out32(0x50002014, 0x20);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x5);
   Xil_Out32(0x5000200C, 0x24);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
