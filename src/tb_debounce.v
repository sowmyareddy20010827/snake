`timescale 1ns/1ns
`include "btn_debounce.v"


module tb_debounce;
    
    reg reset = 1'b0;
    reg clk = 1'b0;
    reg btn_in = 1'b0;
    wire btn_out;
    
    
    btn_debounce tb (
        .clk(clk),
        .reset(reset),
        .btn_in(btn_in),
        .btn_out(btn_out)
    );
   
    
    /* verilator lint_off STMTDLY */
	always #5 clk = ~clk;
    /* verilator lint_on STMTDLY */
    
    initial begin
     $dumpfile ("tb_debounce.vcd");
     $dumpvars ;
    
    /* verilator lint_off STMTDLY */
    #50 reset = 1'b1;
    #10 reset = 1'b0;
    #20 btn_in = 1'b1;
    #1  btn_in = 1'b0;
    #1  btn_in = 1'b1;
    #1  btn_in = 1'b0;
    #1  btn_in = 1'b1;
    #1  btn_in = 1'b0;
    #1  btn_in = 1'b1;
    #1  btn_in = 1'b0;
    #1  btn_in = 1'b1;
    #1  btn_in = 1'b0;
    #1  btn_in = 1'b1;
    #1  btn_in = 1'b0;
    #1  btn_in = 1'b1;
    #1  btn_in = 1'b0;
    #50 btn_in = 1'b1;
    #200 $finish;
    /* verilator lint_on STMTDLY */
end


endmodule
