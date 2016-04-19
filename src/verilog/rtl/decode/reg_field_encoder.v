module reg_field_encoder (
 in,
 sgpr_base,
 vgpr_base,
 out,
 literal_required,
 explicit_vcc,
 explicit_exec,
 explicit_scc,
 explicit_M0,
 fp_constant
);

input [9:0] in;
input [8:0] sgpr_base;
input [9:0] vgpr_base;
output [11:0] out;
output literal_required;
output explicit_vcc;
output explicit_exec;
output explicit_scc;
output explicit_M0;
output [32:0] fp_constant;

reg [11:0] out;
reg literal_required;
reg explicit_vcc;
reg explicit_exec;
reg explicit_scc;
reg explicit_M0;
reg [32:0] fp_constant;

wire [8:0] sgpr_address;
wire [9:0] vgpr_address;
wire signed [9:0] negative_constant;

assign sgpr_address = sgpr_base + in[6:0];
assign vgpr_address = vgpr_base + in[7:0];
assign negative_constant = (~{4'b0,in[5:0]}) + 10'b1;

always @(*)
begin
  casex(in)
    //invalid operand
    10'b0?_????_????:
      begin
        out <= {1'b0,{11{1'bx}}};
        literal_required <= 1'b0;
        explicit_vcc <= 1'b0;
        explicit_exec <= 1'b0;
        explicit_scc <= 1'b0;
        explicit_M0 <= 1'b0;
        fp_constant <= {1'b0,{32{1'bx}}};
      end
    //vgpr
    10'b11_????_????:
      begin
        out <= {2'b10,vgpr_address};
	literal_required <= 1'b0;
        explicit_vcc <= 1'b0;
        explicit_exec <= 1'b0;
        explicit_scc <= 1'b0;
        explicit_M0 <= 1'b0;
        fp_constant <= {1'b0,{32{1'bx}}};
      end
    //Integer constants and reserved fields or literal constant
    10'b10_1???_????:
      begin
        //Zero and positive integer constants
        if(in[6:0] <= 7'd64) begin 
          out <= {5'd0,in[6:0]};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
        //negative integer constant
        else if(in[6:0] <= 7'd80) begin
          out <= {2'b00,negative_constant};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
        //reserved field
        else if(in[6:0] <= 7'd111) begin
          out <= {1'b0,{11{1'bx}}};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
        //floating point constant: 0.5
        else if(in[6:0] == 7'd112) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'h3f00_0000};
        end
        //floating point constant: -0.5
        else if(in[6:0] == 7'd113) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'hbf00_0000};
        end
        //floating point constant: 1.0
        else if(in[6:0] == 7'd114) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'h3f80_0000};
        end
        //floating point constant: -1.0
        else if(in[6:0] == 7'd115) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'hbf80_0000};
        end
        //floating point constant: 2.0
        else if(in[6:0] == 7'd116) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'h4000_0000};
        end
        //floating point constant: -2.0
        else if(in[6:0] == 7'd117) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'hc000_0000};
        end
        //floating point constant: 4.0
        else if(in[6:0] == 7'd118) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'h4080_0000};
        end
        //floating point constant: -4.0
        else if(in[6:0] == 7'd119) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b1,32'hc080_0000};
        end
        //reserved field
        else if(in[6:0] <= 7'd122) begin
          out <= {1'b0,{11{1'bx}}};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
        //VCCZ
	else if(in[6:0] == 7'd123) begin
          out <= {3'b111,9'd32};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b1;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
        //EXECZ
	else if(in[6:0] == 7'd124) begin
          out <= {3'b111,9'd64};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b1;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
        //SCC
	else if(in[6:0] == 7'd125) begin
          out <= {3'b111,9'd128};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b1;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
	//Literal constant in instruction stream!
	else if(in[6:0] == 7'd127) begin
          out <= {1'b0,11'b111_1111_1111};
	  literal_required <= 1'b1;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
	end
        //reserved
        else begin
          out <= {1'b0,{11{1'bx}}};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
      end
    //sgpr or exec or vcc or reserved field
    10'b10_0???_????:
      begin
        //sgpr
        if(in[6:0] <= 7'd103) begin
          out <= {3'b110,sgpr_address};
	  literal_required <= 1'b0;
          explicit_vcc <= 1'b0;
          explicit_exec <= 1'b0;
          explicit_scc <= 1'b0;
          explicit_M0 <= 1'b0;
          fp_constant <= {1'b0,{32{1'bx}}};
        end
        //special registers or reserved fields
        else begin
          casex(in[6:0])
            //VCC_LO
            7'd106:
              begin
                out <= {3'b111,9'd1};
	        literal_required <= 1'b0;
                explicit_vcc <= 1'b1;
                explicit_exec <= 1'b0;
                explicit_scc <= 1'b0;
                explicit_M0 <= 1'b0;
                fp_constant <= {1'b0,{32{1'bx}}};
              end
            //VCC_HI
            7'd107:
              begin
                out <= {3'b111,9'd2};
	        literal_required <= 1'b0;
                explicit_vcc <= 1'b1;
                explicit_exec <= 1'b0;
                explicit_scc <= 1'b0;
                explicit_M0 <= 1'b0;
                fp_constant <= {1'b0,{32{1'bx}}};
              end
            //M0
            7'd124:
              begin
                out <= {3'b111,9'd4};
	        literal_required <= 1'b0;
                explicit_vcc <= 1'b0;
                explicit_exec <= 1'b0;
                explicit_scc <= 1'b0;
                explicit_M0 <= 1'b1;
                fp_constant <= {1'b0,{32{1'bx}}};
              end
            //EXEC_LO
            7'd126:
              begin
                out <= {3'b111,9'd8};
	        literal_required <= 1'b0;
                explicit_vcc <= 1'b0;
                explicit_exec <= 1'b1;
                explicit_scc <= 1'b0;
                explicit_M0 <= 1'b0;
                fp_constant <= {1'b0,{32{1'bx}}};
              end
            //EXEC_HI
            7'd127:
              begin
                out <= {3'b111,9'd16};
	        literal_required <= 1'b0;
                explicit_vcc <= 1'b0;
                explicit_exec <= 1'b1;
                explicit_scc <= 1'b0;
                explicit_M0 <= 1'b0;
                fp_constant <= {1'b0,{32{1'bx}}};
              end
            //reserved field
            default:
              begin
                out <= {1'b0,{11{1'bx}}};
	        literal_required <= 1'b0;
                explicit_vcc <= 1'b0;
                explicit_exec <= 1'b0;
                explicit_scc <= 1'b0;
                explicit_M0 <= 1'b0;
                fp_constant <= {1'b0,{32{1'bx}}};
              end
          endcase
        end
      end
    //Error condition
    default:
      begin
        out <= {1'b0,{11{1'bx}}};
	literal_required <= 1'b0;
        explicit_vcc <= 1'b0;
        explicit_exec <= 1'b0;
        explicit_scc <= 1'b0;
        explicit_M0 <= 1'b0;
        fp_constant <= {1'b0,{32{1'bx}}};
      end
  endcase
end
endmodule
