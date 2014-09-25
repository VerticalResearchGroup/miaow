void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xBF8A0001);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBE830307);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBE820300);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xBE880307);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0xBE820309);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0xBE890301);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xBF810000);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xBE800304);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0xBE810309);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBE810309);
   Xil_Out32(0x50001004, 40);
   Xil_Out32(0x50001000, 0xBE820306);
   Xil_Out32(0x50001004, 44);
   Xil_Out32(0x50001000, 0xBE850304);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x28);
   Xil_Out32(0x5000200C, 0x8);
   Xil_Out32(0x50002010, 0xF);
   Xil_Out32(0x50002014, 0x4);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x15);
   Xil_Out32(0x5000200C, 0x10);
   Xil_Out32(0x50002010, 0x1C);
   Xil_Out32(0x50002014, 0x2E);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x26);
   Xil_Out32(0x5000200C, 0x14);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
