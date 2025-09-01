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
module draw_snake #(
    parameter SIZE = 10, 
    parameter BIT = 10,
    parameter X_START = 320, // start position of snake
    parameter Y_START = 240,
    parameter MAX_BODY_ELEMENTS = 9
) (
    input wire clk,
    input wire reset,
    input wire update,
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos, 
    input wire [2:0] direction,
    input wire [1:0] collision,
    input wire [1:0] game_state,  
    output wire snake_head_active,
    output wire snake_body_active,
    output wire [2:0] rgb
);

parameter snake_rgb = 3'b010; // green


// states control
localparam IDLE = 3'b000;
localparam UP = 3'b001;
localparam DOWN = 3'b010;
localparam LEFT = 3'b011;
localparam RIGHT = 3'b100;

localparam APPLE_COLLECTED = 2'b10;

//states game
localparam PLAY = 2'b01;
localparam GAME_OVER = 2'b11;

integer i,j,k,l,m,n;
reg [BIT-1:0] snakeX, next_snakeX, snakeY, next_snakeY; 
reg [BIT-1:0] bodyX [0:MAX_BODY_ELEMENTS-1];
reg [BIT-1:0] bodyY [0:MAX_BODY_ELEMENTS-1];
reg [BIT-1:0] next_bodyX [0:MAX_BODY_ELEMENTS-1];
reg [BIT-1:0] next_bodyY [0:MAX_BODY_ELEMENTS-1];  
reg body_active, next_body_active;
reg [7:0] body_size, next_body_size;
reg head_active, next_head_active;
reg apple, next_apple;

always @(posedge clk) begin
    if (reset) begin
        snakeX <= X_START;
        snakeY <= Y_START;
        for (i = 0; i < MAX_BODY_ELEMENTS; i = i+1) begin
            bodyX[i] <= 10'd700;
            bodyY[i] <= 10'd500;   
        end    
        body_active <= 1'b0; 
        head_active <= 1'b0;
        body_size <= 8'b00000000;
        apple <= 1'b0;
    end else begin
        snakeX <= next_snakeX;
        snakeY <= next_snakeY;
        for (k = 0; k < MAX_BODY_ELEMENTS; k = k+1) begin
            bodyX[k] <= next_bodyX[k];
            bodyY[k] <= next_bodyY[k];   
        end
        body_active <= next_body_active;
        body_size <= next_body_size;
        head_active <= next_head_active;
        apple <= next_apple;
    end
end

always @(snakeX, snakeY, game_state, direction, update, bodyX[0], bodyY[0], x_pos, y_pos, body_active, body_size, head_active, apple, collision) begin
    // default assignments
    next_snakeX = snakeX;
    next_snakeY = snakeY;
    next_body_active = body_active;
    next_head_active = head_active;
    next_body_size = body_size;
    next_apple = apple;
    for (l = 0; l < MAX_BODY_ELEMENTS; l = l+1) begin 
            next_bodyX[l] = bodyX[l];
            next_bodyY[l] = bodyY[l];   
    end
    
    if (collision == APPLE_COLLECTED && apple == 1'b0) begin
        next_apple = 1'b1;
    end 
    if (apple && collision != APPLE_COLLECTED) begin // increase body size 
        next_body_size = body_size +1;
        next_apple = 1'b0;
    
    end  
    
    if (game_state == PLAY && update) begin
            // shift values in register
            // update all positions
            case (direction) // direction of head
            UP: next_snakeY = (snakeY - SIZE);
            DOWN: next_snakeY = (snakeY + SIZE);
            LEFT : next_snakeX = (snakeX - SIZE);
            RIGHT: next_snakeX = (snakeX + SIZE);
            IDLE: begin 
                    next_snakeY = snakeY;
                    next_snakeX = snakeX;
                  end
            default:begin 
                    next_snakeY = snakeY;
                    next_snakeX = snakeX;
                  end
        endcase 
        for (j = 1; j < MAX_BODY_ELEMENTS; j = j+1) begin
            next_bodyX[j] = bodyX[j-1];
            next_bodyY[j] = bodyY[j-1];   
        end
        next_bodyX[0] = snakeX;
        next_bodyY[0] = snakeY;
        
    end     
    // check if head is at position
    next_head_active = (x_pos >= snakeX) && (x_pos < snakeX + SIZE) && (y_pos >= snakeY) && (y_pos < snakeY + SIZE);
    // check position of body elements
    for (n = 0; n < MAX_BODY_ELEMENTS; n = n + 1) begin
        if (x_pos == bodyX[n] + 1 && (y_pos > bodyY[n] && y_pos < bodyY[n] + SIZE - 1) && body_size >= n+1) begin
            next_body_active = 1'b1;      
        end else if (x_pos == bodyX[n] + SIZE - 1|| y_pos == bodyY[n] + SIZE -1) begin
            next_body_active = 1'b0;
        end 
    end 
    // reset when gameover
    if (game_state == GAME_OVER)  begin  
        //initialise snake head
        next_snakeX = X_START;
        next_snakeY = Y_START;
        next_body_size = 8'b00000000;
        next_apple = 1'b0;
        next_body_active = 1'b0;
        next_head_active = 1'b0;
        for (m = 0; m < MAX_BODY_ELEMENTS; m = m+1) begin
            next_bodyX[m] = 10'd700;
            next_bodyY[m] = 10'd500;   
        end   
          
    end 
end

assign snake_head_active = head_active;
assign snake_body_active = body_active;
assign rgb = snake_rgb;

endmodule

