void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0x4A0C0205);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBF860003);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBE880309);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xBE870304);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0xBE860305);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0xBE840305);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xBE830301);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0x4A0E0409);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0xBF810000);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBE890306);
   Xil_Out32(0x50001004, 40);
   Xil_Out32(0x50001000, 0xBE890304);
   Xil_Out32(0x50001004, 44);
   Xil_Out32(0x50001000, 0xBE810303);
   Xil_Out32(0x50001004, 48);
   Xil_Out32(0x50001000, 0xBE890301);
   Xil_Out32(0x50001004, 52);
   Xil_Out32(0x50001000, 0xBE860305);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0xF);
   Xil_Out32(0x5000200C, 0x26);
   Xil_Out32(0x50002010, 0x20);
   Xil_Out32(0x50002014, 0x22);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x2F);
   Xil_Out32(0x5000200C, 0x4);
   Xil_Out32(0x50002010, 0x31);
   Xil_Out32(0x50002014, 0x14);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0xF);
   Xil_Out32(0x5000200C, 0xD);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
