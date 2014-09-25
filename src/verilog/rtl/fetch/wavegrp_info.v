module wavegrp_info (
	wf_wr_en,
	wr_wf_tag,
	wr_wg_wf_count,
	wr_wfid,
	halt,
	halt_wfid,
	rd_wfid,
	rd_wgid,
	rd_wf_count,
	clk,
	rst
);

input clk;
input rst;

input wf_wr_en;
input [14:0] wr_wf_tag;
input [3:0] wr_wg_wf_count;
input [5:0] wr_wfid;
input [5:0] rd_wfid;
input halt;
input [5:0] halt_wfid;

output [5:0] rd_wgid;
output [3:0] rd_wf_count;

reg [5:0] rd_wgid;
reg [3:0] rd_wf_count;

reg [879:0] write_data;
reg [39:0] write_en;
reg cam_hit;
reg [21:0] cam_data;

wire [879:0] regfile_out;

regfile #(22) wg_cnt_store[39:0] (
	write_data, write_en, regfile_out, clk, rst
);

//assign regfile_out = write_data;

integer i;

//always @(wf_wr_en or wr_wfid or wr_wf_tag /*or regfile_out*/)
always @(*)
begin
	cam_hit = 1'b0;
	cam_data = 22'b0;

	if (wf_wr_en) begin
		for(i = 0; i < 40; i=i+1) begin
			if(/*!cam_hit && */regfile_out[(i*22)+21] &&
					(regfile_out[((i*22)+20)-:11] == wr_wf_tag[14-:11]))
			begin
				cam_data = regfile_out[((i*22)+21)-:22];
				cam_hit = 1'b1;
			end
		end
	end
end

//always @(halt or halt_wfid or cam_hit /*or cam_data*/ or wf_wr_en or wr_wf_tag or wr_wfid or wr_wg_wf_count /*or regfile_out*/) begin
always @(*) begin
	write_en = 40'b0;
	write_data = regfile_out;

	if(halt) begin
		write_data[(halt_wfid*22)+21-:22] = 22'd0;
		write_en[halt_wfid] = 1'b1;
	end

	if (wf_wr_en) begin
   		if(cam_hit == 1'b1) begin
			write_data[(wr_wfid*22)+21-:22] = cam_data;
			write_en[wr_wfid] = 1'b1;
		end
		else begin
			write_data[(wr_wfid*22)+21-:22] = {
				1'b1, wr_wf_tag[14-:11], wr_wfid, wr_wg_wf_count
				};
			write_en[wr_wfid] = 1'b1;
		end
	end
end

always @(rd_wfid or regfile_out)
begin
	rd_wgid = regfile_out[(rd_wfid*22)+9-:6];
	rd_wf_count = regfile_out[(rd_wfid*22)+3-:4];
end

endmodule
