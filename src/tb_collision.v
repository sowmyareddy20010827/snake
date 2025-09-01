`timescale 1ns/1ns

`include "collision.v"

module tb_collision;
    
    reg reset = 1'b0;
    reg clk = 1'b0;
    reg border = 1'b0;
    reg apple = 1'b0;
    reg head = 1'b0;
    reg body = 1'b0;
    wire[1:0] state;

    
    collision tb(
        .clk(clk),
        .reset(reset),
        .red_border(border),
        .red_apple(apple),
        .grn_snake_head(head),
        .grn_snake_body(body),
        .state_o(state)   
    );  
    
    /* verilator lint_off STMTDLY */
    always #20 clk = ~clk;
    /* verilator lint_on STMTDLY */
    

    
    initial begin
    $dumpfile ("tb_collision.vcd");
    $dumpvars ;
    
    /* verilator lint_off STMTDLY */
    #40 reset = 1'b1;
    #40 reset = 1'b0;
    #30 head = 1'b1;
    #60 border = 1'b1;
    #200 border = 1'b0;
    #100 body = 1'b1;
    #60 head = 1'b0;
    #80 head = 1'b1;
    body = 1'b0;
    #90 apple = 1'b1;
    #100 apple = 1'b0;
    #1000 $finish;
    /* verilator lint_on STMTDLY */
end


endmodule
