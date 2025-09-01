`timescale 1ns/1ns

`include "snake.v"
`include "vga_sync.v"
`include "random_position.v"
`include "draw_border.v"
`include "draw_apple.v"
`include "draw_snake.v"
`include "snake_control.v"
`include "collision.v"
`include "rgb_select.v"
`include "btn_debounce.v"
`include "synchronizer.v"
`include "snake_update_trigger.v"

module tb_snake;
    
    reg reset = 1'b0;
    reg clk = 1'b0;
    reg up = 1'b0;
    reg down = 1'b0;
    reg left = 1'b0;
    reg right = 1'b0;
    wire [2:0] rgb_out;
    wire h_sync;
    wire v_sync;
    
    snake tb(
        .clk(clk),
        .reset(reset),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .rgb_out(rgb_out),
        .h_sync_o(h_sync),
        .v_sync_o(v_sync)    
    );
    // write vga values into txt file for use with https://madlittlemods.github.io/vga-simulator/
    integer fd;
    initial fd = $fopen("vga_snake.txt", "w");
   
    
    /* verilator lint_off STMTDLY */
    always #20 clk = ~clk; // 25 MHz
    /* verilator lint_on STMTDLY */
    
    always @(posedge clk) begin
        $fwrite(fd, "%0t ns: %b %b %b%b%b %b%b%b %b%b\n",$time, h_sync, v_sync, rgb_out[2],rgb_out[2],rgb_out[2], rgb_out[1], rgb_out[1], rgb_out[1], rgb_out[0], rgb_out[0]);
    end
    
    initial begin
    $dumpfile ("tb_snake.vcd");
    $dumpvars ;
    
    /* verilator lint_off STMTDLY */
    #60 reset = 1'b1;
    #600 reset = 1'b0;
    #23000 left = 1'b1;
    #400000000 $finish;
    /* verilator lint_on STMTDLY */
    $fclose(fd);
end


endmodule
