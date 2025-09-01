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

module vga_sync
#(
    parameter BIT = 10, // ceil(maxPx=800) 
    parameter[BIT-1:0] HRES = 640,
    parameter[BIT-1:0] VRES = 480,
    parameter[BIT-1:0] H_FRONT_PORCH = 16,
    parameter[BIT-1:0] H_SYNC = 96,
    parameter[BIT-1:0] H_BACK_PORCH = 48,
    parameter[BIT-1:0] V_FRONT_PORCH = 10,
    parameter[BIT-1:0] V_BACK_PORCH = 33,
    parameter[BIT-1:0] V_SYNC = 2
) (
    input wire clk, // 25.179 MHz 
    input wire reset,
    output wire h_sync,
    output wire v_sync,
    output wire[BIT-1:0] x_pos, // x position in px
    output wire[BIT-1:0] y_pos, // y position
    output wire active // 1 if in active region of screen, 0 if not
);

parameter[BIT-1:0] H_TOTAL = HRES + H_FRONT_PORCH + H_SYNC + H_BACK_PORCH; // 800 px
parameter[BIT-1:0] V_TOTAL = VRES + V_FRONT_PORCH + V_SYNC + V_BACK_PORCH; // 525 px

reg[BIT-1:0] hsync_cnt, next_hsync_cnt, vsync_cnt, next_vsync_cnt;

always @(posedge clk) begin: reg_process
    if (reset) begin
        hsync_cnt <= {BIT{1'b0}};
        vsync_cnt <= {BIT{1'b0}};
    end else begin
        hsync_cnt <= next_hsync_cnt;
        vsync_cnt <= next_vsync_cnt;
    end 
end

always @(hsync_cnt, vsync_cnt) begin: combinatorics
    next_hsync_cnt = hsync_cnt;
    next_vsync_cnt = vsync_cnt;
    if (hsync_cnt == H_TOTAL-1) begin
        next_hsync_cnt = {BIT{1'b0}}; // reset horizontal counter
        if (vsync_cnt == V_TOTAL-1) begin
        next_vsync_cnt = {BIT{1'b0}}; // reset vertical counter
    	end else begin
        next_vsync_cnt = vsync_cnt + 1'b1;
    	end
    end else begin
        next_hsync_cnt = hsync_cnt + 1'b1;
    end
end

assign h_sync = ((hsync_cnt < HRES + H_FRONT_PORCH || hsync_cnt > H_TOTAL - H_BACK_PORCH) ? 1'b1 : 1'b0); 
assign v_sync = ((vsync_cnt < VRES + V_FRONT_PORCH || vsync_cnt > V_TOTAL - V_BACK_PORCH) ? 1'b1 : 1'b0); 
assign x_pos = hsync_cnt;
assign y_pos = vsync_cnt;
assign active = (hsync_cnt < HRES && vsync_cnt < VRES) ? 1'b1 : 1'b0;


endmodule
