module inflight_instr_counter
  (/*AUTOARG*/
   // Outputs
   no_inflight_instr_flag, max_inflight_instr_flag,
   // Inputs
   clk, rst, retire_vgpr_1_en, retire_branch_en, retire_sgpr_en,
   issued_en
   );

   // Inputs and outputs
   input clk,rst, retire_vgpr_1_en, 
	 retire_branch_en, retire_sgpr_en,
	 issued_en;


   output no_inflight_instr_flag, max_inflight_instr_flag;

   wire   wr_en;

   // For now, allow only 16 inflight instructions
   wire [3:0] inflight_instr_counter;

   // This will be used to calculate the total number of retired instructions
   wire [1:0] total_retired_instr;
   wire [2:0] total_counter_summed_value;

   // Next counter value   
   wire [3:0] counter_value;
   wire [3:0] next_counter_value;

   // Find the number of retired instructions
   adder1bit adder_retired 
     (
      total_retired_instr[0],
      total_retired_instr[1],
      retire_vgpr_1_en,
      retire_branch_en,
      retire_sgpr_en
      );

   // Calculates:
   // total_counter_summed_value =  (issued_en? 1 : 0) - total_retired_instr  
   adder_param #(3) adder_issued 
     (
      .in1({{2{1'b0}},issued_en}),
      .in2({1'b1,~total_retired_instr}),
      .cin(1'b1),
      .sum(total_counter_summed_value),
      .cout()
      );

   // Calculates the next counter value
   adder_param #(4) adder_next_counter 
     (
      .in1({total_counter_summed_value[2],total_counter_summed_value}),
      .in2(counter_value),
      .cin(1'b0),
      .sum(next_counter_value),
      .cout()
      );

   // Register for the counter value
   register #(4) counter_reg
     (
      .out(counter_value), 
      .in(next_counter_value), 
      .wr_en(wr_en), 
      .clk(clk), 
      .rst(rst)
      );

   // Finds out when to write the counter
   assign wr_en = retire_vgpr_1_en | retire_branch_en |retire_sgpr_en | issued_en;

   // Calculate the no_inflight_instr bit or the max_inflight_instr_bit
   assign no_inflight_instr_flag = ~(|counter_value);
   assign max_inflight_instr_flag = &counter_value;


endmodule


