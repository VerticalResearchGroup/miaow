module mem_wait
(/*AUTOARG*/
    // Outputs
    mem_wait_arry,
    // Inputs
    clk, rst, lsu_valid, lsu_done,
    lsu_wfid, lsu_done_wfid
);

input clk,rst;
input lsu_valid, lsu_done;
input [5:0] lsu_wfid, lsu_done_wfid;

output [`WF_PER_CU-1:0] mem_wait_arry;

wire [`WF_PER_CU-1:0]   decoded_issue_value, decoded_lsu_retire_value,
                        mem_wait_reg_wr_en, mem_waiting_wf;

decoder_6b_40b_en issue_value_decoder
(
    .addr_in(lsu_wfid),
    .out(decoded_issue_value),
    .en(lsu_valid)
);


decoder_6b_40b_en retire_lsu_value_decoder
(
    .addr_in(lsu_done_wfid),
    .out(decoded_lsu_retire_value),
    .en(lsu_done)
);

dff_set_en_rst mem_wait[`WF_PER_CU-1:0]
(
    .q(mem_waiting_wf),
    .d(40'b0),
    .en(mem_wait_reg_wr_en),
    .clk(clk),
    .set(decoded_issue_value),
    .rst(rst)
);

assign mem_wait_reg_wr_en = decoded_lsu_retire_value | decoded_issue_value;

assign mem_wait_arry = mem_waiting_wf;
endmodule
