void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xBF880004);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBE890304);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBE890305);
   Xil_Out32(0x50001004, 12);
   Xil_Out32(0x50001000, 0xBE810309);
   Xil_Out32(0x50001004, 16);
   Xil_Out32(0x50001000, 0xBE830304);
   Xil_Out32(0x50001004, 20);
   Xil_Out32(0x50001000, 0xBE830300);
   Xil_Out32(0x50001004, 24);
   Xil_Out32(0x50001000, 0xBF810000);
   Xil_Out32(0x50001004, 28);
   Xil_Out32(0x50001000, 0xBE830303);
   Xil_Out32(0x50001004, 32);
   Xil_Out32(0x50001000, 0xBE810305);
   Xil_Out32(0x50001004, 36);
   Xil_Out32(0x50001000, 0xBE810300);
   Xil_Out32(0x50001004, 40);
   Xil_Out32(0x50001000, 0xBE810304);
   Xil_Out32(0x50001004, 44);
   Xil_Out32(0x50001000, 0xBE810306);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x28);
   Xil_Out32(0x5000200C, 0x0);
   Xil_Out32(0x50002010, 0x7);
   Xil_Out32(0x50002014, 0x14);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x1C);
   Xil_Out32(0x5000200C, 0x30);
   Xil_Out32(0x50002010, 0x21);
   Xil_Out32(0x50002014, 0x17);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x1);
   Xil_Out32(0x5000200C, 0x25);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
