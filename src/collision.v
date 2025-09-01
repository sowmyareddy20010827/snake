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


// checks if collision occured and returns if collision occured with border, snake body or with apple

`default_nettype none

module collision (
    input wire clk,
    input wire reset,
    input wire border_active, 
    input wire apple_active,
    input wire snake_head_active,
    input wire snake_body_active,
    output wire [1:0] state_o // 00 reset, 01 collision, 10 apple collected, 11 no collision
);

// states
localparam RESET = 2'b00;
localparam COLLISION = 2'b01;
localparam APPLE_COLLECTED = 2'b10;
localparam NO_COLLISION = 2'b11;

reg[1:0] state, next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= RESET;
    end else begin
        state <= next_state;
    end
end

always @(state, border_active, apple_active, snake_head_active, snake_body_active) begin
    next_state = state;
    if ((border_active & snake_head_active) || (snake_body_active & snake_head_active)) begin
        next_state = COLLISION;
    end else if (apple_active & snake_head_active) begin
        next_state = APPLE_COLLECTED;
    end else begin
        next_state = NO_COLLISION;
    end
end

assign state_o = state;
        

endmodule
