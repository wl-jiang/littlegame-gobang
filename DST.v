`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/03 15:57:45
// Design Name: 
// Module Name: CntS
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


//任意数循环计数
module CntS #(
    parameter               WIDTH               = 16,
    parameter               RST_VLU             = 0
)(
    input                   [ 0 : 0]            clk,
    input                   [ 0 : 0]            rstn,   //复位使能
    input                   [WIDTH-1:0]         d,      //置数
    input                   [ 0 : 0]            ce,     //计数使能信号

    output      reg         [WIDTH-1:0]         q
);
always @(posedge clk) begin
    if (!rstn)
        q <= RST_VLU;
    else if (ce) begin
        if (q == 0)    
            q <= d;
        else
            q <= q - 1;
    end
    else
        q <= q;
end
endmodule

module DST (
    input                   [ 0 : 0]            rstn,
    input                   [ 0 : 0]            pclk,

    output      reg         [ 0 : 0]            hen,        //水平显示有效
    output      reg         [ 0 : 0]            ven,        //垂直显示有效
    output      reg         [ 0 : 0]            hs,         //行同步
    output      reg         [ 0 : 0]            vs          //场同步
);

localparam HSW_t    = 119;
localparam HBP_t    = 63;
localparam HEN_t    = 799;
localparam HFP_t    = 55;

localparam VSW_t    = 5;//TODO
localparam VBP_t    = 22;//TODO
localparam VEN_t    = 599;//TODO
localparam VFP_t    = 36;//TODO

localparam SW       = 2'b00;
localparam BP       = 2'b01;
localparam EN       = 2'b10;
localparam FP       = 2'b11;

reg     [ 0 : 0]    ce_v;

reg     [ 1 : 0]    h_state;
reg     [ 1 : 0]    v_state;

reg     [15 : 0]    d_h;
reg     [15 : 0]    d_v;

wire    [15 : 0]    q_h;
wire    [15 : 0]    q_v;

CntS #(16,HSW_t) hcnt(          //每个时钟周期计数器增加1，表示扫描一个像素
    .clk        (pclk),
    .rstn       (rstn),
    .d          (d_h),
    .ce         (1'b1),

    .q          (q_h)
);

CntS #(16,VSW_t) vcnt(          //每行扫描完计数器增加1，表示扫描一行像素点
    //TODO
     .clk        (pclk),
    .rstn       (rstn),
    .d          (d_v),
    .ce         (ce_v),

    .q          (q_v)
);

always @(*) begin
    case (h_state)
        SW: begin
             d_h = HBP_t;  hs = 1; hen = 0;
        end
        BP: begin
            d_h = HEN_t;  hs = 0; hen = 0;
        end
        EN: begin
            d_h = HFP_t;  hs = 0; hen = 1;
        end
        FP: begin
            d_h = HSW_t;  hs = 0; hen = 0;
        end
    endcase
    case (v_state)
        // TODO
        SW: begin
            d_v = VBP_t;  vs = 1; ven = 0;
        end
        BP: begin
            d_v = VEN_t;  vs = 0; ven = 0;
        end
        EN: begin
            d_v = VFP_t;  vs = 0; ven = 1;
        end
        FP: begin
            d_v = VSW_t;  vs = 0; ven = 0;
        end
    endcase
end

always @(posedge pclk) begin
    if (!rstn) begin
        h_state <= SW; v_state <= SW; ce_v <= 1'b0;
    end
    else begin
        if(q_h == 0) begin
            h_state <= h_state + 2'b01;
            if (h_state == FP) begin
                ce_v <= 0;
                if (q_v == 0)
                    v_state <= v_state + 2'b01;
            end
            else
                ce_v <= 0;
        end
        else if (q_h == 1) begin
            if(h_state == FP)
                ce_v <= 1;
            else
                ce_v <= 0;
        end
        else ce_v <= 0;
    end
end
endmodule
