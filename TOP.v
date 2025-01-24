`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/12 18:50:45
// Design Name: 
// Module Name: TOP
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


module TOP #(
    parameter DW=15)(
    input                                       clk,
    input                                       rstn,
    input                   [ 0 : 0]            up,
    input                   [ 0 : 0]            down,
    input                   [ 0 : 0]            left,
    input                   [ 0 : 0]            right,
    input                   [ 0 : 0]            action,
    output                  [ 0 : 0]            hs,
    output                  [ 0 : 0]            vs,
    output                  [ 11 :0]            rgb,
    output                  [0:0]               LED_B,
    output                  [0:0]               LED_G
    );
wire pclk;
wire [11:0] wdata;
wire [DW-1:0] waddr;
wire we;
wire [7:0]  x_current;
wire [7:0]  y_current;

   Pclk plck1(
    .clk_out1(pclk),
    .clk_in1(clk),
    .reset(~rstn),
    .locked()
    );

    Game game(
        .clk(clk),
        .rstn(rstn),
        .pclk(pclk),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .action(action),
        .we(we),
        .wdata(wdata),
        .waddr(waddr),
        .x_current(x_current),
        .y_current(y_current),
        .LED_B(LED_B),
        .LED_G(LED_G)
    );

    VGA vga(
        .clk(clk),
        .pclk(pclk),
        .rstn(rstn),
        .we(we),
        .wdata(wdata),
        .waddr(waddr),
        .hs(hs),
        .vs(vs),
        .rgb(rgb),
        .x_current(x_current),
        .y_current(y_current)
    );

 
endmodule
