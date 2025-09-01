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
module draw_border # (
    parameter BIT = 10
) (
    input wire[BIT-1:0] x_pos,
    input wire[BIT-1:0] y_pos,
    output wire border_active,
    output wire [2:0] rgb
);

// border start and end positions
parameter BORDER_LEFT = 10'd0;
parameter BORDER_RIGHT = 10'd639;
parameter BORDER_BOTTOM = 10'd479;
parameter BORDER_TOP = 10'd0;
parameter BORDER_BIT_WIDTH = 4;
parameter color = 3'b111; // white

// return 1 if border should be drawn at current x and y position
assign border_active = x_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_LEFT[BIT-1: BORDER_BIT_WIDTH] || x_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_RIGHT[BIT-1: BORDER_BIT_WIDTH] || y_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_TOP[BIT-1: BORDER_BIT_WIDTH] || y_pos[BIT-1: BORDER_BIT_WIDTH] == BORDER_BOTTOM[BIT-1: BORDER_BIT_WIDTH];

assign rgb = color;

endmodule
