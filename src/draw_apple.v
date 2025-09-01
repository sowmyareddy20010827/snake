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

module draw_apple # (
    parameter BIT = 10,
    parameter SIZE = 20 // size of apple in px x px
) ( 
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos,
    input wire[BIT-1:0] x_start,
    input wire[BIT-1:0] y_start,   
    output wire apple_active,
    output wire [2:0] rgb
);

parameter color = 3'b100; // color of apple = red

// returns 1 if apple should be drawn at current x and y position
assign apple_active = (x_pos >= x_start) && (x_pos < x_start + SIZE) && (y_pos >= y_start) && (y_pos < y_start + SIZE);
assign rgb = color;

endmodule
