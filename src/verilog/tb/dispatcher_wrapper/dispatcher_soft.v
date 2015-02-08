extern "C" int ScheduleWavefront();
extern "C" void DescheduleWavefront(int cuid, int wfTag);
extern "C" int getTotalWavefronts();
extern "C" int getCuId();
//extern "C" int getWgId();
//extern "C" int getWfId();
extern "C" int getWfTag();
extern "C" int getWfCnt();
extern "C" int getWfNumThrds();
extern "C" int getVregBase();
extern "C" int getVregSize();
extern "C" int getSregBase();
extern "C" int getSregSize();
extern "C" int getLdsBase();
extern "C" int getLdsSize();
extern "C" int getSetVregs();
extern "C" int getVregKey(int index, int thrd);
extern "C" int getVregValue(int index, int thrd);
extern "C" int getSetSregs();
extern "C" int getSregKey(int index);
extern "C" int getSregValue(int index);
extern "C" void setVregValue(int cuid, int thrd, int vreg, int bitnum, int value);
extern "C" void setSregValue(int cuid, int sreg, int bitnum, int value);
extern "C" int getPC();

module dispatcher_soft (/*AUTOARG*/
   // Outputs
   dispatch2cu_wf_dispatch, dispatch2cu_wg_wf_count,
   dispatch2cu_wf_size_dispatch, dispatch2cu_sgpr_base_dispatch,
   dispatch2cu_vgpr_base_dispatch, dispatch2cu_wf_tag_dispatch,
   dispatch2cu_lds_base_dispatch, dispatch2cu_start_pc_dispatch,
   ldssize_out, vregsize_out, sregsize_out,
   // Inputs
   cu2dispatch_wf_done, cu2dispatch_wf_tag_done, rst, clk
   ) ;

   parameter NUMOFCU = 1;

   output reg [(NUMOFCU-1):0] dispatch2cu_wf_dispatch;
   output reg [3:0]           dispatch2cu_wg_wf_count;
   output reg [5:0]           dispatch2cu_wf_size_dispatch;
   output reg [8:0]           dispatch2cu_sgpr_base_dispatch;
   output reg [9:0]           dispatch2cu_vgpr_base_dispatch;
   output reg [14:0]          dispatch2cu_wf_tag_dispatch;
   output reg [15:0]          dispatch2cu_lds_base_dispatch;
   output reg [31:0]          dispatch2cu_start_pc_dispatch;

   output [15:0]              ldssize_out;
   output [9:0]               vregsize_out;
   output [8:0]               sregsize_out;
   
   input [NUMOFCU-1:0]        cu2dispatch_wf_done;
   input [NUMOFCU*15 - 1:0]   cu2dispatch_wf_tag_done;
   
   input 		      rst,clk;
   
   
   reg [15:0]                 ldssize;
   reg [9:0]                  vregsize;
   reg [8:0]                  sregsize;
   reg [31:0]                 sregVal, vregVal;
   integer                    x, y, z;
   integer                    m, n;
   integer                    thrds, setVregs, setSregs;
   integer                    sregKey, vregKey;
   integer                    cuid;
   integer                    a;
   
   


   always @ (posedge clk) begin
      if (rst) begin
	     // check       <= 1'b0;
	     dispatch2cu_wf_dispatch <= 'b0;
      end
   end

   always @ (posedge clk) begin
      if (!rst) begin
	     if (ScheduleWavefront()==1'b1) begin
	        #1;
            
	        thrds		= getWfNumThrds();
	        setVregs	= getSetVregs();
	        setSregs	= getSetSregs();
	        cuid		= getCuId();

	        // set vregs
	        for (x = 0; x < setVregs; x++) begin
	           vregKey = getVregKey(x, 0);
	           for (y = 0; y < thrds; y++) begin
		          vregVal = getVregValue(x, y);
		          // set the vregister
		          for(a = 0; a < 32; a++) begin
		             setVregValue(cuid, y, vregKey, a, vregVal[a]);
		             //DUT[cuid].vgpr0.reg_file.bank[y].word[vregKey].bits[a].dff_0.state = vregVal[a];
		          end
	           end
	        end

	        // set sregs
	        for (z = 0; z < setSregs; z++) begin
	           sregKey = getSregKey(z);
	           sregVal = getSregValue(z);
	           // set the sregister
	           for(a = 0; a < 32; a++) begin
		          setSregValue(cuid, sregKey, a, sregVal[a]);
		          //DUT[cuid].sgpr0.sgpr_reg_file.word[sregKey].bits[a].dff_0.state = sregVal[a];
	           end
	        end

	        dispatch2cu_vgpr_base_dispatch     <= getVregBase();
	        dispatch2cu_sgpr_base_dispatch     <= getSregBase();
	        dispatch2cu_lds_base_dispatch      <= getLdsBase();
	        vregsize     <= getVregSize();
	        sregsize     <= getSregSize();
	        ldssize      <= getLdsSize();
	        dispatch2cu_start_pc_dispatch      <= getPC();
	        dispatch2cu_wf_size_dispatch       <= getWfNumThrds() - 1;
	        dispatch2cu_wf_tag_dispatch        <= getWfTag();
	        dispatch2cu_wg_wf_count            <= getWfCnt();

	        for (m = 0; m < NUMOFCU; m++) begin
	           // $display("CUID: %d",getCuId());
	           if(m==getCuId()) dispatch2cu_wf_dispatch[m]  <= 1'b1;
	           else dispatch2cu_wf_dispatch[m] <= 1'b0;
	           // $display("m: %d dispatch2cu_wf_dispatch: %d",m,dispatch2cu_wf_dispatch[m]);
	        end
	     end
	     else begin
	        for ( m = 0; m < NUMOFCU; m++) begin
	           dispatch2cu_vgpr_base_dispatch     <= 10'bx;
	           dispatch2cu_sgpr_base_dispatch     <= 9'bx;
	           dispatch2cu_lds_base_dispatch      <= 16'bx;
	           vregsize     <= 10'bx;
	           sregsize     <= 9'bx;
	           ldssize      <= 16'bx;
	           dispatch2cu_start_pc_dispatch      <= 32'bx;
	           dispatch2cu_wf_size_dispatch       <= 6'bx;
	           dispatch2cu_wf_tag_dispatch        <= 11'bx;
	           dispatch2cu_wf_dispatch[m]         <= 1'b0;
	        end
	     end

      end
   end

   always @ (posedge clk) begin
      for(n=0; n<NUMOFCU; n++) begin
	     if (cu2dispatch_wf_done[n]) begin
	        DescheduleWavefront(n, cu2dispatch_wf_tag_done[((n * 15) + 14)-:15]); 	// cuid
         end
      end
   end

   assign ldssize_out = ldssize;
   assign vregsize_out = vregsize;
   assign sregsize_out = sregsize;
   
   
endmodule // dispatcher_wrapper
