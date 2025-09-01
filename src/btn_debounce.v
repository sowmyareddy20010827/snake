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

//simple debouncer for push buttons

module btn_debounce (
    input wire clk,
    input wire reset,
    input wire btn_in,
    output wire btn_out
);

parameter COUNTER_BIT = 16;
parameter COUNTER_VAL = 50000; // 20 ms at about 25 MHz clk

reg [COUNTER_BIT-1:0] counter, next_counter;
reg btn, next_btn;


always @(posedge clk) begin: register_process
    if (reset) begin
        counter <= {COUNTER_BIT{1'b0}};
        btn <= 1'b0;
    end else begin
        counter <= next_counter;
        btn <= next_btn;
    end
end

always @(counter, btn, btn_in) begin: combinatorics
    next_counter = counter;
    next_btn = btn;
    if (btn_in) begin 
        next_counter = counter + 1'b1;
        if (counter == COUNTER_VAL) begin // output is only 1 when input is held at 1 for counter to reach COUNTER_VAL without having been reset
            next_btn = 1'b1;
        end
    end else begin
        next_counter = {COUNTER_BIT{1'b0}};
        next_btn = 1'b0;
    end 
end

assign btn_out = btn;

endmodule

