`timescale 1ns/1ns

`include "vga_sync.v"

module tb_vga_sync;
    
    reg reset = 1'b0;
    reg clk = 1'b0;
    wire hsync;
    wire vsync;
    wire[9:0] x_pos;
    wire[9:0] y_pos;
    wire active;
    
    
    vga_sync tb(
        .clk(clk),
        .reset(reset),
        .h_sync(hsync),
        .v_sync(vsync),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .active(active)
    );
   
    
    /* verilator lint_off STMTDLY */
    always #20 clk = ~clk;
    /* verilator lint_on STMTDLY */
    
    initial begin
     $dumpfile ("tb_vga_sync.vcd");
     $dumpvars ;
    
    /* verilator lint_off STMTDLY */
    #150 reset = 1'b1;
    #80 reset = 1'b0;
    #500000000 $finish;
    /* verilator lint_on STMTDLY */
end


endmodule
