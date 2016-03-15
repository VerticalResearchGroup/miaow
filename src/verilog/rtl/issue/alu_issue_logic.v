module alu_issue_logic
(/*AUTOARG*/
    // Outputs
    c_issued_valid, c_simd0_alu_select, c_simd1_alu_select,
    c_simd2_alu_select, c_simd3_alu_select, c_simf0_alu_select,
    c_simf1_alu_select, c_simf2_alu_select, c_simf3_alu_select,
    c_lsu_lsu_select, c_salu_alu_select, c_issued_wfid,
    // Inputs
    clk, rst, f_lsu_ready, f_salu_alu_ready, f_simf3_alu_ready,
    f_simf2_alu_ready, f_simf1_alu_ready, f_simf0_alu_ready,
    f_simd3_alu_ready, f_simd2_alu_ready, f_simd1_alu_ready,
    f_simd0_alu_ready, lsu_wf_valid, simd_wf_valid, simf_wf_valid,
    salu_wf_valid, lsu_wf_chosen, simd_wf_choosen, simf_wf_choosen,
    salu_wf_choosen
);

input clk,rst;

input   f_lsu_ready, f_salu_alu_ready,
        f_simf3_alu_ready,f_simf2_alu_ready,
        f_simf1_alu_ready,f_simf0_alu_ready,
        f_simd3_alu_ready,f_simd2_alu_ready,
        f_simd1_alu_ready,f_simd0_alu_ready;


input lsu_wf_valid, simd_wf_valid, simf_wf_valid ,salu_wf_valid;
input [`WF_ID_LENGTH-1:0] lsu_wf_chosen, simd_wf_choosen, simf_wf_choosen, salu_wf_choosen;

output  c_issued_valid;
output  c_simd0_alu_select, c_simd1_alu_select, 
        c_simd2_alu_select, c_simd3_alu_select, 
        c_simf0_alu_select, c_simf1_alu_select, 
        c_simf2_alu_select, c_simf3_alu_select, 
        c_lsu_lsu_select, c_salu_alu_select;

output [`WF_ID_LENGTH-1:0] c_issued_wfid;

reg [`WF_ID_LENGTH-1:0] c_issued_wfid;


wire [1:0] last_fu_selected;

reg [1:0] curr_fu_selected;

reg_param #(2) last_fu(.out(last_fu_selected), .in(curr_fu_selected), 
          .wr_en(c_issued_valid), .clk(clk), .rst(rst));


reg c_issued_valid;
reg c_simd0_alu_select, c_simd1_alu_select, 
    c_simd2_alu_select, c_simd3_alu_select, 
    c_simf0_alu_select, c_simf1_alu_select, 
    c_simf2_alu_select, c_simf3_alu_select, 
    c_lsu_lsu_select, c_salu_alu_select;
             
reg [3:0] fu_ready_shifted, fu_selected_shifted;
reg [3:0] fu_ready_arry, fu_selected_arry;
         
always @(*) begin

    fu_ready_arry <= { (f_simd0_alu_ready | f_simd1_alu_ready | f_simd2_alu_ready | 
    f_simd3_alu_ready) & simd_wf_valid,
    (f_simf0_alu_ready | f_simf1_alu_ready | f_simf2_alu_ready | 
    f_simf3_alu_ready) & simf_wf_valid,
    f_lsu_ready & lsu_wf_valid,
    f_salu_alu_ready & salu_wf_valid };

      // Select one fu based on round robin between fu classes
    case( last_fu_selected )
        2'b00 : fu_ready_shifted <= fu_ready_arry;
        2'b01 : fu_ready_shifted <= {fu_ready_arry[0], fu_ready_arry[3:1]};
        2'b10 : fu_ready_shifted <= {fu_ready_arry[1:0], fu_ready_arry[3:2]};
        2'b11 : fu_ready_shifted <= {fu_ready_arry[2:0], fu_ready_arry[3]};
    endcase

    casex( fu_ready_shifted )
        4'b1??? : begin
            fu_selected_shifted <= fu_ready_shifted & 4'b1000;
            curr_fu_selected <= 2'h3;
        end

        4'b01?? : begin
            fu_selected_shifted <= fu_ready_shifted & 4'b0100;
            curr_fu_selected <= 2'h2;
        end

        4'b001? : begin 
            fu_selected_shifted <= fu_ready_shifted & 4'b0010;
            curr_fu_selected <= 2'h1;
        end
                      
        4'b0001 : begin
            fu_selected_shifted <= fu_ready_shifted & 4'b0001;
            curr_fu_selected <= 2'h0;
        end
           
        default : begin
            fu_selected_shifted <= 4'b0000;
            curr_fu_selected <= last_fu_selected;
        end
    endcase // casex ( fu_ready_shifted )

    case( last_fu_selected )
        2'b00 : fu_selected_arry <= fu_selected_shifted;
        2'b01 : fu_selected_arry <= {fu_selected_shifted[2:0], fu_selected_shifted[3]};
        2'b10 : fu_selected_arry <= {fu_selected_shifted[1:0], fu_selected_shifted[3:2]};
        2'b11 : fu_selected_arry <= {fu_selected_shifted[0], fu_selected_shifted[3:1]};
    endcase // case ( last_fu_selected )

    // With the class selected, we select the correct alu
    casex( { f_simd0_alu_ready,f_simd1_alu_ready,f_simd2_alu_ready,f_simd3_alu_ready} )
        4'b1??? : begin
            c_simd0_alu_select <= fu_selected_arry[3];
            c_simd1_alu_select <= 1'b0;
            c_simd2_alu_select <= 1'b0;
            c_simd3_alu_select <= 1'b0;
        end

        4'b01?? : begin
            c_simd0_alu_select <= 1'b0;
            c_simd1_alu_select <= fu_selected_arry[3];
            c_simd2_alu_select <= 1'b0;
            c_simd3_alu_select <= 1'b0;
        end

        4'b001? : begin
            c_simd0_alu_select <= 1'b0;
            c_simd1_alu_select <= 1'b0;
            c_simd2_alu_select <= fu_selected_arry[3];
            c_simd3_alu_select <= 1'b0;
        end

        4'b0001 : begin
            c_simd0_alu_select <= 1'b0;
            c_simd1_alu_select <= 1'b0;
            c_simd2_alu_select <= 1'b0;
            c_simd3_alu_select <= fu_selected_arry[3];
        end

        default : begin
            c_simd0_alu_select <= 1'b0;
            c_simd1_alu_select <= 1'b0;
            c_simd2_alu_select <= 1'b0;
            c_simd3_alu_select <= 1'b0;
        end
    endcase

    casex( { f_simf0_alu_ready,f_simf1_alu_ready,f_simf2_alu_ready,f_simf3_alu_ready} )
        4'b1??? : begin
            c_simf0_alu_select <= fu_selected_arry[2];
            c_simf1_alu_select <= 1'b0;
            c_simf2_alu_select <= 1'b0;
            c_simf3_alu_select <= 1'b0;
        end

        4'b01?? : begin
            c_simf0_alu_select <= 1'b0;
            c_simf1_alu_select <= fu_selected_arry[2];
            c_simf2_alu_select <= 1'b0;
            c_simf3_alu_select <= 1'b0;
        end

        4'b001? : begin
            c_simf0_alu_select <= 1'b0;
            c_simf1_alu_select <= 1'b0;
            c_simf2_alu_select <= fu_selected_arry[2];
            c_simf3_alu_select <= 1'b0;
        end

        4'b0001 : begin
            c_simf0_alu_select <= 1'b0;
            c_simf1_alu_select <= 1'b0;
            c_simf2_alu_select <= 1'b0;
            c_simf3_alu_select <= fu_selected_arry[2];
        end

        default : begin
            c_simf0_alu_select <= 1'b0;
            c_simf1_alu_select <= 1'b0;
            c_simf2_alu_select <= 1'b0;
            c_simf3_alu_select <= 1'b0;
        end

    endcase

    c_lsu_lsu_select <= fu_selected_arry[1];
    c_salu_alu_select <= fu_selected_arry[0];
      
      // Select the correct wfid
    case( fu_selected_arry )
        4'b1000 : c_issued_wfid <= simd_wf_choosen;
        4'b0100 : c_issued_wfid <= simf_wf_choosen;
        4'b0010 : c_issued_wfid <= lsu_wf_chosen;
        4'b0001 : c_issued_wfid <= salu_wf_choosen;
        default : c_issued_wfid <= {`WF_ID_LENGTH{1'bx}};
    endcase // case ( fu_selected_arry )

    c_issued_valid <= |fu_selected_arry;
end

endmodule
