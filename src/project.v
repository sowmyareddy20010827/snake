// Copyright 2024 Stefan Hirschböck
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License. 
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE−2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and
// limitations under the License.

`default_nettype none

module tt_um_histefan_top (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [2:0] rgb_o;
    wire reset = !rst_n;    
	

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    assign uio_out = 8'b0;
 
       
snake snake_game (
    .clk(clk),
    .reset(reset),
    .up(ui_in[7]),
    .down(ui_in[6]),
    .left(ui_in[5]),
    .right(ui_in[4]),
    .rgb_out(rgb_o),
    .h_sync_o(uo_out[7]),
    .v_sync_o(uo_out[3])
);
   
	// assign vga outputs to be compatible with tiny vga pmod
    assign uo_out[0] = rgb_o[2]; // red 1
    assign uo_out[1] = rgb_o[1]; // green 1
    assign uo_out[2] = rgb_o[0]; // blue 1
    assign uo_out[4] = rgb_o[2]; // red 0
    assign uo_out[5] = rgb_o[1]; // green 0
    assign uo_out[6] = rgb_o[0]; // blue 0
	
	

endmodule
