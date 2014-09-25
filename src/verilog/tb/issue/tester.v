module tester(
    clk,
    rst
);
parameter end_simulation = 32'hffff;


output clk,rst;
reg clk, rst;
integer clk_count;

integer tests_done;
integer tests_failed;

initial begin
    forever begin
        #10 clk <= ~clk;
        if(clk) clk_count = clk_count + 1;
        if(clk_count == end_simulation) begin
           $display("not ok - Simulation took too long"); 
           tests_failed = tests_failed+1;    
           print_report();
           $finish;
       end
    end
end

initial begin
    clk = 0;
    rst = 0;
    clk_count = 0;
    tests_done = 0;
    tests_failed = 0;
end

task reset_module;
begin
    wait_clock();
    rst = 1;
    wait_clock();
    wait_clock();
    rst = 0;
end
endtask

task wait_clock;
begin
    @( negedge clk );
end
endtask

task check_boolean;
    input test_result;
    input[0:400] description;
    reg test_result;
    reg [0:400] description;
begin
    tests_done = tests_done + 1;
    if(test_result) $display("ok - %s",description);
    else begin
        $display("not ok - %s",description);
        tests_failed = tests_failed + 1;
    end
end
endtask

task check_value;    
    parameter VALUE_WIDTH = 32;
    input[VALUE_WIDTH-1:0] value,corr_value;
    input[0:400] description;
    reg[VALUE_WIDTH-1:0] value,corr_value;
    reg[0:400] description;
begin    
    tests_done = tests_done + 1;
    if(value === corr_value) $display("ok - %s",description);
    else begin
        $display("not ok - %s # found %h, expected %h",description,value,corr_value);
        tests_failed = tests_failed + 1;    
    end
end
endtask

task print_report;
    begin
        if(tests_failed == 0) $display("\n#################\n# All tests passed!\n");
        else $display("\n#################\n# Failed %0d/%0d tests\n",tests_failed,tests_done );
    end
endtask

endmodule
