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

module rgb_select (
    input wire reset,
    input wire active,
    input wire active_border,
    input wire active_apple,
    input wire active_snake_head,
    input wire active_snake_body,
    input wire [2:0] rgb_border,
    input wire [2:0] rgb_apple,
    input wire [2:0] rgb_snake,
    output reg[2:0] rgb_out
);

// select color to display on screen 
// decide priority of color to draw when to objects occupy the same space on the display
// priority: white > green > red
always @(*) begin
    rgb_out = 3'b000;
    if (active && !reset) begin
        if (active_apple) begin
            rgb_out = rgb_apple;
        end
        if (active_snake_head || active_snake_body) begin
            rgb_out = rgb_snake;
        end
        if (active_border) begin
            rgb_out = rgb_border;
        end   
    end 

end

endmodule
