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

// module that allows snake to be updated with a frequency of less than 60 Hz allowing the snake speed to be adjusted
module snake_update_trigger #(
    parameter BIT = 10,
    parameter V_SYNC_COUNT = 490,
    parameter H_SYNC_COUNT = 656,
    parameter COUNTER = 2 // trigger update when this value is reached, update at about 60/COUNTER Hz
) (
    input wire clk,
    input wire reset,
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos,
    output wire update_trigger

);

reg[7:0] cnt, next_cnt;
reg update, next_update;
// generate update trigger for drawing next position of snake
always @(posedge clk) begin
    if (reset) begin
        cnt <= 8'b00000000;
        update <= 1'b0;
    end else begin
        cnt <= next_cnt;
        update <= next_update;
    end
end

always @(cnt, y_pos, x_pos, update) begin
    next_cnt = cnt;
    next_update = update;
    if (y_pos == V_SYNC_COUNT && x_pos == H_SYNC_COUNT) begin
        next_cnt = cnt + 8'b00000001;
    end
    if (cnt == COUNTER && update == 1'b0) begin // update trigger only for 1 clk cycle
        next_update = 1'b1;
        next_cnt = 8'b00000000;
    end else begin
        next_update = 1'b0;
    end   
end

assign update_trigger = update;

endmodule
