void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0x7D0A0C03);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x2F);
   Xil_Out32(0x5000200C, 0x25);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x1E);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x14);
   Xil_Out32(0x5000200C, 0x17);
   Xil_Out32(0x50002010, 0x2E);
   Xil_Out32(0x50002014, 0x11);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x27);
   Xil_Out32(0x5000200C, 0x2C);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
