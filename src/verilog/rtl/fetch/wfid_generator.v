module wfid_generator(
	halt, 
	WF_tag, 
	WF_id_done, 
	vacant, 
	vacant_next, 
	WF_id, 
	WF_tag_done, 
	clk, 
	wr, 
	rst
);

input clk;
input rst;
input halt;
input wr;
input [14:0] WF_tag;
input [5:0] WF_id_done; //rename
input [39:0] vacant;

output [39:0] vacant_next;
output [5:0] WF_id; //new id generated
output [14:0] WF_tag_done; //rename

encoder encoder1(vacant, WF_id);
vacant_mask_gen vmg(WF_id, vacant_next, WF_id_done, vacant, halt, wr);

regblock #(15) wf_tag_store (
	WF_tag_done, clk, rst, 
	WF_id_done, WF_id, WF_tag, wr
);

endmodule
