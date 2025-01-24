`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 13:09:44
// Design Name: 
// Module Name: VGA
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


module VGA #(
    parameter DW=15)(
   input            rstn,
    input            clk,
    input            pclk,
    input           [DW-1:0]   waddr,
    input           [11:0]   wdata,
    input [7:0]     x_current,
    input [7:0]     y_current,
    input            we,
    output  [0:0]    hs,
    output  [0:0]    vs,
    output  [11:0]   rgb
    );
wire [11:0] rdata;
wire [DW-1:0] raddr;

DU du(
    .pclk(pclk),
    .rstn(rstn),
    .hs(hs),
    .vs(vs),
    .rgb(rgb),
    .rdata(rdata),
    .raddr(raddr),
    .x_current(x_current),
    .y_current(y_current)
);
blk_mem_gen_0 BRAM (
  .clka(clk),    // input wire clka
  .wea(we),      // input wire [0 : 0] wea
  .addra(waddr),  // input wire [15 : 0] addra
  .dina(wdata),    // input wire [15 : 0] dina
  .clkb(pclk),    // input wire clkb
  .enb(1),      // input wire enb
  .addrb(raddr),  // input wire [15 : 0] addrb
  .doutb(rdata)  // output wire [15 : 0] doutb
);

endmodule
