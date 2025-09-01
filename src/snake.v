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

module snake #(
    parameter BIT = 10
) (
    input wire clk, // 25.179 MHz
    input wire reset,
    input wire up,
    input wire down,
    input wire left,
    input wire right,
    output wire [2:0] rgb_out,
    output reg h_sync_o,
    output reg v_sync_o 
);

// ### state machine ###
localparam IDLE = 2'b00;
localparam PLAY = 2'b01;
localparam GAME_OVER = 2'b11;
// collision trigger states
localparam COLLISION = 2'b01;
localparam APPLE_COLLECTED = 2'b10;

/*##### input synchronization and btn debounce #####*/
wire sync_up, sync_down, sync_left, sync_right, debounce_up, debounce_down, debounce_left, debounce_right;

reg[1:0] state, next_state; // GAME STATE
// collision
wire [1:0] collision_state;
// ### snake drawing and collision logic ###
wire snake_head_active, snake_body_active;
wire [2:0] rgb_snake;
wire update_snake;
// ### controls ###
wire[2:0] snake_direction;
wire apple_active;
wire[2:0] rgb_apple;
// ### apple position and drawing ###
wire rand_trigger;
reg apple_trigger, next_apple_trigger;
wire[BIT-1:0] apple_x, apple_y;
//### Border drawing ###
wire border_active;
wire[2:0] rgb_border;
//### VGA Control Signal Creation ###
wire h_sync, v_sync, active;
wire [BIT-1:0] x_pos, y_pos;
wire [2:0] rgb_select_out;

// initialise all modules needed 

synchronizer up_sync (
    .clk(clk),
    .reset(reset),
    .async_in(up),
    .sync_out(sync_up)
);

btn_debounce up_debounce (
    .clk(clk),
    .reset(reset),
    .btn_in(sync_up),
    .btn_out(debounce_up)
);

synchronizer down_sync (
    .clk(clk),
    .reset(reset),
    .async_in(down),
    .sync_out(sync_down)
);

btn_debounce down_debounce (
    .clk(clk),
    .reset(reset),
    .btn_in(sync_down),
    .btn_out(debounce_down)
);

synchronizer left_sync (
    .clk(clk),
    .reset(reset),
    .async_in(left),
    .sync_out(sync_left)
);

btn_debounce left_debounce (
    .clk(clk),
    .reset(reset),
    .btn_in(sync_left),
    .btn_out(debounce_left)
);

synchronizer right_sync (
    .clk(clk),
    .reset(reset),
    .async_in(right),
    .sync_out(sync_right)
);

btn_debounce right_debounce (
    .clk(clk),
    .reset(reset),
    .btn_in(sync_right),
    .btn_out(debounce_right)
);

vga_sync #(
    .BIT(BIT),
    .HRES(640),
    .VRES(480),
    .H_FRONT_PORCH(16),
    .H_SYNC(96),
    .H_BACK_PORCH(48),
    .V_FRONT_PORCH(10),
    .V_BACK_PORCH(33),
    .V_SYNC(2)
) sync_signal_gen (
    .clk(clk),
    .reset(reset),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .x_pos(x_pos),
    .y_pos(y_pos),
    .active(active)
);

rgb_select colour_out (
    .reset(reset),
    .active(active),
    .active_border(border_active),
    .active_apple(apple_active),
    .active_snake_head(snake_head_active),
    .active_snake_body(snake_body_active),
    .rgb_border(rgb_border),
    .rgb_apple(rgb_apple),
    .rgb_snake(rgb_snake),
    .rgb_out(rgb_select_out)
);

draw_border game_border (
    .x_pos(x_pos),
    .y_pos(y_pos),
    .border_active(border_active),
    .rgb(rgb_border)
);

random_position apple_pos(
    .clk(clk),
    .reset(reset),
    .new_number_trigger(rand_trigger),
    .x_out(apple_x),
    .y_out(apple_y)
);

draw_apple game_apple (
    .x_pos(x_pos),
    .y_pos(y_pos),
    .x_start(apple_x),
    .y_start(apple_y),
    .apple_active(apple_active),
    .rgb(rgb_apple) 
);


snake_control game_control (
    .clk(clk),
    .reset(reset),
    .up(debounce_up),
    .down(debounce_down),
    .left(debounce_left),
    .right(debounce_right),
    .game_state(state),
    .direction(snake_direction)
);


snake_update_trigger snake_update_trigger (
    .clk(clk),
    .reset(reset),
    .x_pos(x_pos),
    .y_pos(y_pos),
    .update_trigger(update_snake)
);

draw_snake game_snake (
    .clk(clk),
    .reset(reset),
    .update(update_snake),
    .x_pos(x_pos),
    .y_pos(y_pos),
    .direction(snake_direction),
    .collision(collision_state),
    .game_state(state),
    .snake_head_active(snake_head_active),
    .snake_body_active(snake_body_active),
    .rgb(rgb_snake) 
);

collision game_collision (
    .clk(clk),
    .reset(reset),
    .border_active(border_active),
    .apple_active(apple_active),
    .snake_head_active(snake_head_active),
    .snake_body_active(snake_body_active),
    .state_o(collision_state)
);


assign rgb_out = (active) ? rgb_select_out : 3'b000;

// Register syncs to align with output data.
always @(posedge clk)
begin
    v_sync_o <= v_sync;
    h_sync_o <= h_sync;
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        apple_trigger <= 1'b0;
    end else begin
        state <= next_state;
        apple_trigger <= next_apple_trigger;
    end 
end


// next state combinatorics
always @(state, debounce_up, debounce_down, debounce_left, debounce_right, collision_state, apple_trigger) begin
    next_state = state;
    next_apple_trigger = apple_trigger;
    if (debounce_up || debounce_down || debounce_left || debounce_right) begin
        next_state = PLAY;
    end
    if (collision_state == COLLISION) begin
        next_state = GAME_OVER;
    end
    if (collision_state == APPLE_COLLECTED) begin // generate new apple position when collision with apple occured
        next_apple_trigger = 1'b1;
    end else begin
        next_apple_trigger = 1'b0;
    end
    if (state == GAME_OVER) begin
        next_state = IDLE;
    end 
end

assign rand_trigger = apple_trigger;


endmodule

