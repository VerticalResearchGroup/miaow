void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0x0A081008);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x8);
   Xil_Out32(0x5000200C, 0x9);
   Xil_Out32(0x50002010, 0x21);
   Xil_Out32(0x50002014, 0x24);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x1);
   Xil_Out32(0x5000200C, 0x2E);
   Xil_Out32(0x50002010, 0x30);
   Xil_Out32(0x50002014, 0x19);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x1C);
   Xil_Out32(0x5000200C, 0x2);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
