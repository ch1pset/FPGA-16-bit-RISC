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
    parameter ADD = 0, SUB = 1, AND = 2, OR = 3,
              XOR = 4, NOT = 5, SLA = 6, SRA = 7,
              LI = 8, LW = 9, SW = 10, BIZ = 11,
              BNZ = 12, JAL = 13, JMP = 14, JR = 15;
    reg [15:0] MEM [255:0];
    
    initial
    begin
        MEM[0] = instr(LI, 0, 0, 8'h05);
        MEM[1] = instr(LI, 1, 0, 8'h07);
        MEM[2] = instr(ADD, 2, 0, 1);
        MEM[3] = 16'h1310;
        MEM[4] = 16'ha206;
        MEM[5] = 16'ha307;
    end

    always@(posedge clk)
    begin
        if(read) data_out = MEM[addr];
        if(write) MEM[addr] = data_in;
    end

    function [15:0] instr;
    input [3:0] op, rd, rs;
    input [7:0] rt;
    instr = (op << 12) + (rd << 8) + (rs << 4) + rt;
    endfunction

endmodule
