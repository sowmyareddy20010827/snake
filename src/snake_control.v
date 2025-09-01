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

module snake_control (
    input clk,
    input wire reset,
    input wire up,
    input wire down,
    input wire left,
    input wire right,
    input wire [1:0] game_state,
    output wire[2:0] direction // 000 no movement, 001 up, 010 down, 011 left, 100 right
);

localparam IDLE = 3'b000;
localparam UP = 3'b001;
localparam DOWN = 3'b010;
localparam LEFT = 3'b011;
localparam RIGHT = 3'b100;

//states game
localparam GAME_OVER = 2'b11;

reg[2:0] state, next_state;

always @(posedge clk) begin 
    if (reset) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(state, up, down, left, right, game_state) begin
    next_state = state;
    // snake cant run into its own body by changing direction
    if (up && state != DOWN) begin
        next_state = UP;
    end else if (down && state != UP) begin
        next_state = DOWN;
    end else if (left && state != RIGHT) begin
        next_state = LEFT;
    end else if (right && state != LEFT) begin
        next_state = RIGHT;
    end else begin
        next_state = state;
    end
    if (game_state == GAME_OVER) begin
        next_state = IDLE;
    end
end

assign direction = state;

endmodule
