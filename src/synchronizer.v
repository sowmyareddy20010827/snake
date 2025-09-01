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

//synchronizer with 2 FF

module synchronizer (
    input wire clk,
    input wire reset,
    input wire async_in,
    output wire sync_out 
);

reg sync_ff1;
reg sync_ff2;

always @(posedge clk) begin
    if (reset) begin
        sync_ff1 <= 1'b0;
        sync_ff2 <= 1'b0;
    end else begin
        sync_ff1 <= async_in;
        sync_ff2 <= sync_ff1;
    end
end

assign sync_out = sync_ff2;

endmodule
    
        
