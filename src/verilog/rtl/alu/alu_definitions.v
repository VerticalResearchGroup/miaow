/**
 * alu_definitions.v
 * File that contains all definitions used throughout alu
 * stage
 ***/

`ifndef _alu_definitions_v_
`define _alu_definitions_v_

`define MODULE_SIMD 0
`define MODULE_SIMF 1

`define ALU_VOPC_FORMAT 8'h01
`define ALU_VOP1_FORMAT 8'h02
`define ALU_VOP2_FORMAT 8'h04
`define ALU_VOP3B_FORMAT 8'h08
`define ALU_VOP3A_FORMAT 8'h10

`define ALU_VOP3A_NEG1_POS 23
`define ALU_VOP3A_NEG2_POS 22
`define ALU_VOP3A_NEG3_POS 21
`define ALU_VOP3A_OMOD1_POS 20
`define ALU_VOP3A_OMOD2_POS 19
`define ALU_VOP3A_CLAMP_POS 18
`define ALU_VOP3A_ABS1_POS 17
`define ALU_VOP3A_ABS2_POS 16
`define ALU_VOP3A_ABS3_POS 15

`define ALU_VOP3B_NEG1_POS 23
`define ALU_VOP3B_NEG2_POS 22
`define ALU_VOP3B_NEG3_POS 21
`define ALU_VOP3B_OMOD1_POS 20
`define ALU_VOP3B_OMOD2_POS 19

`endif // _alu_definitions_v_
