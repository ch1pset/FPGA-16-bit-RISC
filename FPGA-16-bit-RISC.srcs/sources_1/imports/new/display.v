`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2019 01:41:13 PM
// Design Name: 
// Module Name: display
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


module RefreshDisplay #(parameter rate) (
    input [31:0] display_data,
    input clk_in,
    input en,
    output [7:0] SSEG_CA,
    output [7:0] SSEG_AN
    );
    reg [2:0] count = 3'b000;
    wire refresh_trigger;

    SlowClock #(rate)   D_CLK(clk_in, refresh_trigger);
    AnodeCon            POS_SEL(count, refresh_trigger, en, SSEG_AN);
    CathodeCon          DIGIT_SEL(display_data[4*count +: 4], refresh_trigger, en, SSEG_CA);
    
    always@(posedge refresh_trigger)
    begin
        count = count + 1;
    end
    
endmodule

module SlowClock #(parameter clk_ms) (
    input INCLK,
    output reg OUTCLK = 0
    );
    parameter ms = 100000;
    reg [15:0] slow;
    always@(posedge INCLK)
    begin
        if(slow < (clk_ms * ms))
            slow = slow + 1;
        else begin
            slow = 0;
            OUTCLK = ~OUTCLK; // tick every 1 ms
        end
    end
endmodule

module CathodeCon (
    input [3:0] BIN,
    input CLK,
    input EN,
    output reg [7:0] SSEG_CA
    );
    reg [7:0] HEX_ROM [15:0];
    reg [7:0] OFF;
    initial 
    begin
        HEX_ROM[ 0] = ~8'b11111100;
        HEX_ROM[ 1] = ~8'b01100000;
        HEX_ROM[ 2] = ~8'b11011010;
        HEX_ROM[ 3] = ~8'b11110010;
        HEX_ROM[ 4] = ~8'b01100110;
        HEX_ROM[ 5] = ~8'b10110110;
        HEX_ROM[ 6] = ~8'b10111110;
        HEX_ROM[ 7] = ~8'b11100000;
        HEX_ROM[ 8] = ~8'b11111110;
        HEX_ROM[ 9] = ~8'b11110110;
        HEX_ROM[10] = ~8'b11101110;
        HEX_ROM[11] = ~8'b00111110;
        HEX_ROM[12] = ~8'b10011100;
        HEX_ROM[13] = ~8'b01111010;
        HEX_ROM[14] = ~8'b10011110;
        HEX_ROM[15] = ~8'b10001110;
        OFF = ~8'b00000000;
    end
    
    always@(posedge CLK)
    begin
        if(EN)
            SSEG_CA = HEX_ROM[BIN];
        else
            SSEG_CA = OFF;
    end
endmodule

module AnodeCon (
    input [2:0] POS,
    input CLK,
    input EN,
    output reg [7:0] SSEG_AN
    );
    reg [7:0] POS_ROM [7:0];
    reg [7:0] OFF;
    initial
    begin
        POS_ROM[0] = ~8'h01;
        POS_ROM[1] = ~8'h02;
        POS_ROM[2] = ~8'h04;
        POS_ROM[3] = ~8'h08;
        POS_ROM[4] = ~8'h10;
        POS_ROM[5] = ~8'h20;
        POS_ROM[6] = ~8'h40;
        POS_ROM[7] = ~8'h80;
        OFF = ~8'h00;
    end
    
    always@(posedge CLK)
    begin
        if(EN)
            SSEG_AN = POS_ROM[POS];
        else
            SSEG_AN = OFF;
    end
endmodule