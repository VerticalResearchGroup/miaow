module wfid_mux_9to1 (
  wr_port_select,

  wfid_done_0,
  wfid_0,
  wfid_done_1,
  wfid_1,
  wfid_done_2,
  wfid_2,
  wfid_done_3,
  wfid_3,
  wfid_done_4,
  wfid_4,
  wfid_done_5,
  wfid_5,
  wfid_done_6,
  wfid_6,
  wfid_done_7,
  wfid_7,
  muxed_wfid,
  muxed_wfid_done
);

  output [5:0] muxed_wfid;
  output muxed_wfid_done;

  input [15:0] wr_port_select;

  input wfid_done_0;
  input [5:0] wfid_0;
  input wfid_done_1;
  input [5:0] wfid_1;
  input wfid_done_2;
  input [5:0] wfid_2;
  input wfid_done_3;
  input [5:0] wfid_3;
  input wfid_done_4;
  input [5:0] wfid_4;
  input wfid_done_5;
  input [5:0] wfid_5;
  input wfid_done_6;
  input [5:0] wfid_6;
  input wfid_done_7;
  input [5:0] wfid_7;

  reg [5:0] muxed_wfid;
  reg muxed_wfid_done;

  always @ (
    wr_port_select or
    wfid_done_0 or
    wfid_0 or
    wfid_done_1 or
    wfid_1 or
    wfid_done_2 or
    wfid_2 or
    wfid_done_3 or
    wfid_3 or
    wfid_done_4 or
    wfid_4 or
    wfid_done_5 or
    wfid_5 or
    wfid_done_6 or
    wfid_6 or
    wfid_done_7 or
    wfid_7
  ) begin
    casex(wr_port_select)
      16'h0001:
        begin
          muxed_wfid_done <= wfid_done_0;
          muxed_wfid <= wfid_0;
        end
      16'h0002:
        begin
          muxed_wfid_done <= wfid_done_1;
          muxed_wfid <= wfid_1;
        end
      16'h0004:
        begin
          muxed_wfid_done <= wfid_done_2;
          muxed_wfid <= wfid_2;
        end
      16'h0008:
        begin
          muxed_wfid_done <= wfid_done_3;
          muxed_wfid <= wfid_3;
        end
      16'h0010:
        begin
          muxed_wfid_done <= wfid_done_4;
          muxed_wfid <= wfid_4;
        end
      16'h0020:
        begin
          muxed_wfid_done <= wfid_done_5;
          muxed_wfid <= wfid_5;
        end
      16'h0040:
        begin
          muxed_wfid_done <= wfid_done_6;
          muxed_wfid <= wfid_6;
        end
      16'h0080:
        begin
          muxed_wfid_done <= wfid_done_7;
          muxed_wfid <= wfid_7;
        end
      16'h0000:
        begin
          muxed_wfid_done <= 1'b0;
          muxed_wfid <= {6{1'bx}};
        end
      default:
        begin
          muxed_wfid_done <= 1'bx;
          muxed_wfid <= {6{1'bx}};
        end
    endcase
  end

endmodule
