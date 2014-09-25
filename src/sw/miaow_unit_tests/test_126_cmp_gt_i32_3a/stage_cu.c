void stage_cu()
{
   // Writing instruction memory
   Xil_Out32(0x50001004, 0);
   Xil_Out32(0x50001000, 0xD1080001);
   Xil_Out32(0x50001004, 4);
   Xil_Out32(0x50001000, 0x04161008);
   Xil_Out32(0x50001004, 8);
   Xil_Out32(0x50001000, 0xBF810000);

   // Writing SGPRs for wavefront 1
   Xil_Out32(0x50002004, 0);
   Xil_Out32(0x50002008, 0x18);
   Xil_Out32(0x5000200C, 0xC);
   Xil_Out32(0x50002010, 0x25);
   Xil_Out32(0x50002014, 0x24);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 16);
   Xil_Out32(0x50002008, 0x23);
   Xil_Out32(0x5000200C, 0x28);
   Xil_Out32(0x50002010, 0x20);
   Xil_Out32(0x50002014, 0x13);
   Xil_Out32(0x50002000, 1);
   Xil_Out32(0x50002004, 32);
   Xil_Out32(0x50002008, 0x30);
   Xil_Out32(0x5000200C, 0xD);
   Xil_Out32(0x50002010, 0x0);
   Xil_Out32(0x50002014, 0x0);
   Xil_Out32(0x50002000, 1);
}
