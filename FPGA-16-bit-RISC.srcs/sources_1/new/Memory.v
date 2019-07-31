`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2019 10:48:23 AM
// Design Name: 
// Module Name: Memory
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


module Memory(
    input [7:0] addr,
    input [15:0] data_in,
    input RW,
    input clk,
    output reg [15:0] data_out
    );
    reg [15:0] MEM [255:0];
    integer i;
    initial for(i = 0; i < 256; i = i + 1) MEM[i] = 16'h0000;

    always@(posedge clk)
    begin
        case(RW)
        0: data_out = MEM[addr];
        1: MEM[addr] = data_in;
        endcase
    end
endmodule
