void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xD8340000);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0x06000908);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x18);
   Xil_Out32(0x5000200C, 0x3);
   Xil_Out32(0x50002010, 0x22);
   Xil_Out32(0x50002014, 0x1);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x22);
   Xil_Out32(0x5000200C, 0x2E);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x19);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0xC);
   Xil_Out32(0x5000200C, 0x30);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
