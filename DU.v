`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 19:52:42
// Design Name: 
// Module Name: DU
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


module DU#(
    parameter DW = 15
)(
    input            rstn,
    input            pclk,
    input   [11:0]   rdata,
    input [7:0]      x_current,
    input [7:0]      y_current,
    output  [0:0]    hs,
    output  [0:0]    vs,
    output  [11:0]   rgb,
    output  [DW-1:0] raddr
);
wire hen,ven;

DST dst(
    .rstn(rstn),
    .pclk(pclk),
    .hen(hen),
    .ven(ven),
    .hs(hs),
    .vs(vs)
);
DDP ddp(
    .rstn(rstn),
    .pclk(pclk),
    .rdata(rdata),
    .hen(hen),
    .ven(ven),
    .rgb(rgb),
    .raddr(raddr),
    .x_current(x_current),
    .y_current(y_current)
);
endmodule

