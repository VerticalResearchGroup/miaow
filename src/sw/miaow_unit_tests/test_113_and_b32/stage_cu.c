void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0x36100003);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x2);
   Xil_Out32(0x5000200C, 0x21);
   Xil_Out32(0x50002010, 0x2B);
   Xil_Out32(0x50002014, 0x21);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x2B);
   Xil_Out32(0x5000200C, 0x1F);
   Xil_Out32(0x50002010, 0x2C);
   Xil_Out32(0x50002014, 0x22);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x23);
   Xil_Out32(0x5000200C, 0x26);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
