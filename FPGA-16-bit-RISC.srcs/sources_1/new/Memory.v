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
    input read, write,
    input clk,
    output reg [15:0] data_out
    );
    // parameter ADD = 0, SUB = 1, AND = 2, OR = 3,
    //           XOR = 4, NOT = 5, SLA = 6, SRA = 7,
    //           LI = 8, LW = 9, SW = 10, BIZ = 11,
    //           BNZ = 12, JAL = 13, JMP = 14, JR = 15;
    reg [15:0] MEM [255:0];
    
    // initial
    // begin
    //     MEM[0] = 16'h8005;
    //     MEM[1] = 16'h8107;
    //     MEM[2] = 16'h0201;
    //     MEM[3] = 16'h1310;
    //     MEM[4] = 16'ha206;
    //     MEM[5] = 16'ha307;
    // end

    always@(posedge clk)
    begin
        if(read) data_out = MEM[addr];
        if(write) MEM[addr] = data_in;
    end
endmodule
