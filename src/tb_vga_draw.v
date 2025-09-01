`timescale 1ns/1ns

`include "vga_draw.v"

module tb_vga_draw;
    
    reg reset = 1'b1;
    reg clk = 1'b0;
    reg trigger = 1'b0;
    wire red_o;
    wire grn_o;
    wire blu_o;
    wire h_sync;
    wire v_sync;
    
    vga_draw tb(
        .clk(clk),
        .reset(reset),
        .trigger(trigger),
        .red_o(red_o),
        .grn_o(grn_o),
        .blu_o(blu_o),
        .h_sync_o(h_sync),
        .v_sync_o(v_sync)    
    );
    // write vga values into txt file for use with https://madlittlemods.github.io/vga-simulator/
    integer fd;
    initial fd = $fopen("vga_draw_test.txt", "w");
   
    
    /* verilator lint_off STMTDLY */
    always #20 clk = ~clk;
    /* verilator lint_on STMTDLY */
    
    always @(posedge clk) begin
        $fwrite(fd, "%0t ns: %b %b %b%b%b %b%b%b %b%b\n",$time, h_sync, v_sync, red_o,red_o,red_o, grn_o, grn_o, grn_o, blu_o, blu_o);
    end
    
    initial begin
    $dumpfile ("tb_vga_draw.vcd");
    $dumpvars ;
    
    /* verilator lint_off STMTDLY */
    #40 reset = 1'b0;
    #204200 trigger = 1'b1;
    #50000000 $finish;
    /* verilator lint_on STMTDLY */
    $fclose(fd);
end


endmodule
