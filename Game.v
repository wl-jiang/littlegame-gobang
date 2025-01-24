`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/12 16:48:03
// Design Name: 
// Module Name: Game
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


module Game#(
    parameter               DW                  = 15,
    parameter               TimePerAction       = 10000     // 0.5s
)(
input        clk,
input        rstn,
input        pclk,
// 方向，接 DB
    input                   [ 0 : 0]            up,
    input                   [ 0 : 0]            down,
    input                   [ 0 : 0]            left,
    input                   [ 0 : 0]            right,
    input                   [ 0 : 0]            action,
    output       reg           [ 0 : 0]            we,
    output      reg         [DW-1:0]            waddr,
    output       reg           [11 : 0]            wdata,
    output      reg [7:0]                         x_current,
    output      reg [7:0]                         y_current,
    output      reg                         LED_B,
    output      reg                         LED_G
    );
localparam H_LEN = 200;
localparam V_LEN = 150;
reg [7 : 0]    x_coordinate;
reg [7 : 0]    y_coordinate;  
reg sign;
reg init_over;
reg black_action_over;
reg white_action_over;
reg ena;
localparam INIT = 4'b0000;          
localparam BLACK_MOVE = 4'b0001;          
localparam WHITE_MOVE = 4'b0010;        
localparam BLACK_ACTION = 4'b0011;
localparam WHITE_ACTION = 4'b0100;
localparam IF_BLACK_WIN = 4'b0101;
localparam IF_WHITE_WIN = 4'b0110;
localparam BLACK_WIN = 4'b0111;
localparam WHITE_WIN = 4'b1000;
localparam RESET = 4'b1001;
reg [3:0] current_state, next_state;
reg [7:0] x_temp=0,y_temp=0;
reg temp;
reg [1:0] bw[22:0][22:0];
reg overb;
reg overw;
reg xy;
reg [7:0] x;
reg [7:0] y;
reg [3:0] i;
reg [3:0] j;
wire [11:0] rdata_rst;
reg read_write;
always @(posedge clk) begin
    if (!rstn)  
        current_state <= RESET;
    else 
        current_state <= next_state;
end


always @(*) begin
        next_state = current_state;
        case (current_state)
            INIT: begin
                if (init_over) 
                    next_state = BLACK_MOVE;
                else
                    next_state = INIT;
            end
            BLACK_MOVE: begin
                if(p_action&&bw[(x_current-5)/10+4][(y_current-5)/10+4]==2'b00)
                    next_state = BLACK_ACTION;
                else
                    next_state = BLACK_MOVE;
            end
            BLACK_ACTION: begin
                if(black_action_over)
                    next_state = IF_BLACK_WIN;
            end
            WHITE_MOVE: begin
                if(p_action&&bw[(x_current-5)/10+4][(y_current-5)/10+4]==2'b00)
                    next_state = WHITE_ACTION;
                else
                    next_state = WHITE_MOVE;
            end
            WHITE_ACTION: begin
                if(white_action_over)
                    next_state = IF_WHITE_WIN;
            end
            IF_BLACK_WIN: begin
                if(overb)
                    next_state = BLACK_WIN;
                else if(i==5)
                    next_state = WHITE_MOVE;
            end
            IF_WHITE_WIN: begin
                if(overw)
                    next_state = WHITE_WIN;
                else if(j==5)
                    next_state = BLACK_MOVE;
            end
            BLACK_WIN:
                next_state = BLACK_WIN;
            WHITE_WIN:
                next_state = WHITE_WIN;
            RESET: begin
                if(waddr==H_LEN*V_LEN)
                    next_state = INIT;
            end
            default: next_state = INIT;
        endcase
    end


always @(posedge clk) begin
    if(!rstn) begin
        //TODO
        x_coordinate <= 5;
        y_coordinate <= 5;
        x_current <= 75;
        y_current <= 75;
        x<=0;
        y<=0;
        init_over <= 0;
        sign <= 0;
        temp <= 0;
        // bw[22:0][22:0] <= 2'b00;
        LED_B <= 0;
        LED_G <= 0;
        overb <= 0;
        overw <= 0;
        black_action_over <= 0;
        white_action_over <= 0;
        i <= 0;
        j <= 0;
        ena<=0;
        waddr<=0;
    end
    else begin
        case(current_state)
            INIT: begin
                ena <= 0;
                we <= 1;
                waddr <= x_coordinate + y_coordinate * H_LEN;
                //画横竖棋盘格
                if(!sign) begin
                    if(x_coordinate == 5 || x_coordinate == 15 || x_coordinate == 25 || x_coordinate == 35 || x_coordinate == 45 || x_coordinate == 55 || x_coordinate == 65 || x_coordinate == 75 || x_coordinate == 85 || x_coordinate == 95 || x_coordinate == 105 || x_coordinate == 115 || x_coordinate == 125 || x_coordinate == 135) begin
                        wdata <= 12'h000;//hei
                        y_coordinate <= y_coordinate + 1;
                        if (y_coordinate == 145) begin
                            x_coordinate <= x_coordinate + 10;
                            y_coordinate <= 5;
                        end
                    end
                    else if(x_coordinate == 145) begin
                        wdata <= 12'h000;//hei
                        y_coordinate <= y_coordinate + 1;
                        if (y_coordinate == 145) begin
                            x_coordinate <= 5;
                            y_coordinate <= 5;
                            sign <= 1;
                        end
                    end
                    else begin
                        x_coordinate <= 5;
                        y_coordinate <= 5;
                    end
                end
                else begin
                    if(y_coordinate == 5 || y_coordinate == 15 || y_coordinate == 25 || y_coordinate == 35 || y_coordinate == 45 || y_coordinate == 55 || y_coordinate == 65 || y_coordinate == 75 || y_coordinate == 85 || y_coordinate == 95 || y_coordinate == 105 || y_coordinate == 115 || y_coordinate == 125 || y_coordinate == 135) begin
                        wdata <= 12'h000;//hei
                        x_coordinate <= x_coordinate + 1;
                        if (x_coordinate == 145) begin
                            y_coordinate <= y_coordinate + 10;
                            x_coordinate <= 5;
                        end    
                    end
                    else if(y_coordinate == 145) begin
                        wdata <= 12'h000;//hei
                        x_coordinate <= x_coordinate + 1;
                        if (x_coordinate == 145) begin
                        
                            init_over <= 1;
                            x_coordinate <= 5;
                            y_coordinate <= 5;

                        end    
                    end    
                end
            
            end
            BLACK_MOVE: begin
                if(p_up&&y_current>5) begin
                    y_current <= y_current - 10;
                end
                else if(p_down&&y_current<145) begin
                    y_current <= y_current + 10;
                end
                else if(p_left&&x_current>5) begin
                    x_current <= x_current - 10;
                end
                else if(p_right&&x_current<145) begin
                    x_current <= x_current + 10;
                end
            end
            WHITE_MOVE: begin
                if(p_up&&y_current>5) begin
                    y_current <= y_current - 10;
                end
                else if(p_down&&y_current<145) begin
                    y_current <= y_current + 10;
                end
                else if(p_left&&x_current>5) begin
                    x_current <= x_current - 10;
                end
                else if(p_right&&x_current<145) begin
                    x_current <= x_current + 10;
                end
            end

            BLACK_ACTION: begin
                bw[(x_current-5)/10+4][(y_current-5)/10+4] <= 1;
                xy<= 0;
                if(temp==0) begin
                    x_temp <= x_current;
                    y_temp <= y_current-4;
                    temp <= 1;
                end
                else begin
                    waddr <= x_temp + y_temp * H_LEN;
                    white_action_over <= 0;
                    if(y_temp==y_current+4&&x_temp==x_current) begin
                        wdata <= 12'h000;
                        we <= 0;
                        temp <= 0;
                        black_action_over <= 1;
                    end
                    
                    else if(x_temp<=x_current+3&&x_temp>=x_current-3&&y_temp<=y_current+3&&y_temp>=y_current-3&&~(x_temp==x_current-3&&y_temp==y_current-3)&&~(x_temp==x_current+3&&y_temp==y_current-3)&&~(x_temp==x_current-3&&y_temp==y_current+3)&&~(x_temp==x_current+3&&y_temp==y_current+3)) begin
                        we <= 1;
                        wdata <= 12'h000;
                    end
                    else begin
                        we <= 0;
                    end
                    x_temp <= x_temp + 1;
                    if(x_temp==x_current+5) begin
                        x_temp <= x_current-4;
                        y_temp <= y_temp + 1;
                    end
                end
            end
            WHITE_ACTION: begin
                bw[(x_current-5)/10+4][(y_current-5)/10+4] <= 2;
                xy<=0;
                if(temp==0) begin
                    x_temp <= x_current;
                    y_temp <= y_current-4;
                    temp <= 1;
                end
                else begin
                    waddr <= x_temp + y_temp * H_LEN;
                    black_action_over <= 0;
                    if(y_temp==y_current+4&&x_temp==x_current) begin
                        wdata <= 12'hfff;
                        we <= 0;
                        temp <= 0;
                        white_action_over <= 1;
                    end
                    
                        else if(x_temp<=x_current+3&&x_temp>=x_current-3&&y_temp<=y_current+3&&y_temp>=y_current-3&&~(x_temp==x_current-3&&y_temp==y_current-3)&&~(x_temp==x_current+3&&y_temp==y_current-3)&&~(x_temp==x_current-3&&y_temp==y_current+3)&&~(x_temp==x_current+3&&y_temp==y_current+3)) begin
                        we <= 1;
                        wdata <= 12'hfff;
                    end
                    else begin
                        we <= 0;
                    end
                    x_temp <= x_temp + 1;
                    if(x_temp==x_current+5) begin
                        x_temp <= x_current-4;
                        y_temp <= y_temp + 1;
                    end
                end
            end

            IF_BLACK_WIN: begin
                if(xy==0) begin
                    x<=(x_current-5)/10+4;
                    y<=(y_current-5)/10+4;
                    j<=0;
                    xy<=1;
                end
                else begin
                    if(bw[x][y+i] == 1 && bw[x][y+i-1] == 1 && bw[x][y+i-2] == 1 && bw[x][y+i-3] == 1 && bw[x][y+i-4] == 1) begin
                        overb <= 1;
                    end 
                    else if(bw[x+i][y] == 1 && bw[x+i-1][y] == 1 && bw[x+i-2][y] == 1 && bw[x+i-3][y] == 1 && bw[x+i-4][y] == 1) begin
                        overb <= 1;
                    end
                    else if(bw[x+i][y-i] == 1 && bw[x+i-1][y-i+1] == 1 && bw[x+i-2][y-i+2] == 1 && bw[x+i-3][y-i+3] == 1 && bw[x+i-4][y-i+4] == 1) begin
                        overb <= 1;
                    end 
                    else if(bw[x+i][y+i] == 1 && bw[x+i-1][y+i-1] == 1 && bw[x+i-2][y+i-2] == 1 && bw[x+i-3][y+i-3] == 1 && bw[x+i-4][y+i-4] == 1) begin
                        overb <= 1;
                    end
                    else
                        i<= i + 1;
                end
            end
            IF_WHITE_WIN: begin
                if(xy==0)begin
                    x<=(x_current-5)/10+4;
                    y<=(y_current-5)/10+4;
                    i<=0;
                    xy<=1;
                end
                else begin
                    if(bw[x][y+j] == 2 && bw[x][y+j-1] == 2 && bw[x][y+j-2] == 2 && bw[x][y+j-3] == 2 && bw[x][y+j-4] == 2) begin
                        overw <= 1;
                    end 
                    else if(bw[x+j][y] == 2 && bw[x+j-1][y] == 2 && bw[x+j-2][y] == 2 && bw[x+j-3][y] == 2 && bw[x+j-4][y] == 2) begin
                        overw <= 1;
                    end
                    else if(bw[x+j][y-j] == 2 && bw[x+j-1][y-j+1] == 2 && bw[x+j-2][y-j+2] == 2 && bw[x+j-3][y-j+3] == 2 && bw[x+j-4][y-j+4] == 2) begin
                        overw <= 1;
                    end 
                    else if(bw[x+j][y+j] == 2 && bw[x+j-1][y+j-1] == 2 && bw[x+j-2][y+j-2] == 2 && bw[x+j-3][y+j-3] == 2 && bw[x+j-4][y+j-4] == 2) begin
                        overw <= 1;
                    end
                    else 
                        j<= j + 1;
                end
            end

            BLACK_WIN: begin
                LED_B<=1;
            end
            WHITE_WIN: begin
                LED_G<=1;
            end

            RESET: begin
                if(y<=18)begin
                    bw[x][y] <= 0;
                    x <=x+1;
                    if(x == 18) begin
                        x <= 4;
                        y <= y + 1;
                    end
                    we<=1;
                    ena<=1;
                end
                else begin
                    if(read_write)begin
                        wdata<=rdata_rst;
                        read_write<=0;
                    end
                    else begin
                        waddr<=waddr+1;
                        read_write<=1;
                    end

                end
            end
        endcase
    end
end


PS ps_up(
    .s(up),
    .clk(clk),
    .p(p_up)
);
PS ps_down(
    .s(down),
    .clk(clk),
    .p(p_down)
);
PS ps_left(
    .s(left),
    .clk(clk),
    .p(p_left)
);
PS ps_right(
    .s(right),
    .clk(clk),
    .p(p_right)
);
PS ps_action(
    .s(action),
    .clk(clk),
    .p(p_action)
);
blk_mem_gen_1 ROM (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .addra(waddr),  // input wire [15 : 0] addra
  .douta(rdata_rst)  // output wire [15 : 0] douta
);
endmodule
