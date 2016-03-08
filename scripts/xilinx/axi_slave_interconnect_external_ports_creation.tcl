# Run this script after adding the axi_slave_0 peripheral to your design to automatically create the interface ports


startgroup
create_bd_port -dir I -from 31 -to 0 instruction_buff_out_a_in
connect_bd_net [get_bd_pins /axi_slave_0/instruction_buff_out_a_in] [get_bd_ports instruction_buff_out_a_in]
endgroup
startgroup
create_bd_port -dir I cu2dispatch_wf_done_in
connect_bd_net [get_bd_pins /axi_slave_0/cu2dispatch_wf_done_in] [get_bd_ports cu2dispatch_wf_done_in]
endgroup
startgroup
create_bd_port -dir I -from 31 -to 0 resultsReadyTag_in
connect_bd_net [get_bd_pins /axi_slave_0/resultsReadyTag_in] [get_bd_ports resultsReadyTag_in]
endgroup
startgroup
create_bd_port -dir I -from 127 -to 0 quadData_in
connect_bd_net [get_bd_pins /axi_slave_0/quadData_in] [get_bd_ports quadData_in]
endgroup
startgroup
create_bd_port -dir I -from 3 -to 0 fpgamem2mb_op
connect_bd_net [get_bd_pins /axi_slave_0/fpgamem2mb_op] [get_bd_ports fpgamem2mb_op]
endgroup
startgroup
create_bd_port -dir I -from 31 -to 0 fpgamem2mb_data
connect_bd_net [get_bd_pins /axi_slave_0/fpgamem2mb_data] [get_bd_ports fpgamem2mb_data]
endgroup
startgroup
create_bd_port -dir I -from 31 -to 0 fpgamem2mb_addr
connect_bd_net [get_bd_pins /axi_slave_0/fpgamem2mb_addr] [get_bd_ports fpgamem2mb_addr]
endgroup
startgroup
create_bd_port -dir I -from 31 -to 0 pc_value
connect_bd_net [get_bd_pins /axi_slave_0/pc_value] [get_bd_ports pc_value]
endgroup
startgroup
create_bd_port -dir I -from 2047 -to 0 singleVectorData_in
connect_bd_net [get_bd_pins /axi_slave_0/singleVectorData_in] [get_bd_ports singleVectorData_in]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 waveID_out
connect_bd_net [get_bd_pins /axi_slave_0/waveID_out] [get_bd_ports waveID_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 baseVGPR_out
connect_bd_net [get_bd_pins /axi_slave_0/baseVGPR_out] [get_bd_ports baseVGPR_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 baseSGPR_out
connect_bd_net [get_bd_pins /axi_slave_0/baseSGPR_out] [get_bd_ports baseSGPR_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 baseLDS_out
connect_bd_net [get_bd_pins /axi_slave_0/baseLDS_out] [get_bd_ports baseLDS_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 waveCount_out
connect_bd_net [get_bd_pins /axi_slave_0/waveCount_out] [get_bd_ports waveCount_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 pcStart_out
connect_bd_net [get_bd_pins /axi_slave_0/pcStart_out] [get_bd_ports pcStart_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 instrAddrReg_out
connect_bd_net [get_bd_pins /axi_slave_0/instrAddrReg_out] [get_bd_ports instrAddrReg_out]
endgroup
startgroup
create_bd_port -dir O -from 3 -to 0 lsu2sgpr_dest_wr_en_out
connect_bd_net [get_bd_pins /axi_slave_0/lsu2sgpr_dest_wr_en_out] [get_bd_ports lsu2sgpr_dest_wr_en_out]
endgroup
startgroup
create_bd_port -dir O -from 9 -to 0 quadBaseAddress_out
connect_bd_net [get_bd_pins /axi_slave_0/quadBaseAddress_out] [get_bd_ports quadBaseAddress_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 quadData0_out
connect_bd_net [get_bd_pins /axi_slave_0/quadData0_out] [get_bd_ports quadData0_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 quadData1_out
connect_bd_net [get_bd_pins /axi_slave_0/quadData1_out] [get_bd_ports quadData1_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 quadData2_out
connect_bd_net [get_bd_pins /axi_slave_0/quadData2_out] [get_bd_ports quadData2_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 quadData3_out
connect_bd_net [get_bd_pins /axi_slave_0/quadData3_out] [get_bd_ports quadData3_out]
endgroup
startgroup
create_bd_port -dir O execute_out
connect_bd_net [get_bd_pins /axi_slave_0/execute_out] [get_bd_ports execute_out]
endgroup
startgroup
create_bd_port -dir O executeStart_out
connect_bd_net [get_bd_pins /axi_slave_0/executeStart_out] [get_bd_ports executeStart_out]
endgroup
startgroup
create_bd_port -dir O -from 3 -to 0 instrBuffWrEn_out
connect_bd_net [get_bd_pins /axi_slave_0/instrBuffWrEn_out] [get_bd_ports instrBuffWrEn_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 axi_data_out
connect_bd_net [get_bd_pins /axi_slave_0/axi_data_out] [get_bd_ports axi_data_out]
endgroup
startgroup
create_bd_port -dir O -from 31 -to 0 mb2fpgamem_data_in
connect_bd_net [get_bd_pins /axi_slave_0/mb2fpgamem_data_in] [get_bd_ports mb2fpgamem_data_in]
endgroup
startgroup
create_bd_port -dir O mb2fpgamem_data_we
connect_bd_net [get_bd_pins /axi_slave_0/mb2fpgamem_data_we] [get_bd_ports mb2fpgamem_data_we]
endgroup
startgroup
create_bd_port -dir O mb2fpgamem_ack
connect_bd_net [get_bd_pins /axi_slave_0/mb2fpgamem_ack] [get_bd_ports mb2fpgamem_ack]
endgroup
startgroup
create_bd_port -dir O mb2fpgamem_done
connect_bd_net [get_bd_pins /axi_slave_0/mb2fpgamem_done] [get_bd_ports mb2fpgamem_done]
endgroup
startgroup
create_bd_port -dir O -from 0 -to 0 peripheral_aresetn
connect_bd_net [get_bd_pins /axi_slave_0/peripheral_aresetn] [get_bd_ports peripheral_aresetn]
endgroup
startgroup
create_bd_port -dir O -from 9 -to 0 singleVectorBaseAddress_out
connect_bd_net [get_bd_pins /axi_slave_0/singleVectorBaseAddress_out] [get_bd_ports singleVectorBaseAddress_out]
endgroup

startgroup
create_bd_port -dir O -from 2047 -to 0 singleVectorWrData_out
connect_bd_net [get_bd_pins /axi_slave_0/singleVectorWrData_out] [get_bd_ports singleVectorWrData_out]
endgroup
startgroup
create_bd_port -dir O -from 63 -to 0 singleVectorWrDataMask_out
connect_bd_net [get_bd_pins /axi_slave_0/singleVectorWrDataMask_out] [get_bd_ports singleVectorWrDataMask_out]
endgroup
startgroup
create_bd_port -dir O -from 3 -to 0 singleVectorWrEn_out
connect_bd_net [get_bd_pins /axi_slave_0/singleVectorWrEn_out] [get_bd_ports singleVectorWrEn_out]
endgroup

regenerate_bd_layout
save_bd_design
