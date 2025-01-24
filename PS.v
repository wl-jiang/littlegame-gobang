`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/03 17:04:09
// Design Name: 
// Module Name: PS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PS#(
        parameter  WIDTH = 1
)
(
        input             s,
        input             clk,
        output            p
);
reg delay;
reg delay1;
always @(posedge clk) begin
    delay <= s;
    delay1 <= delay;
end
assign p = (delay) && (~delay1);

endmodule
