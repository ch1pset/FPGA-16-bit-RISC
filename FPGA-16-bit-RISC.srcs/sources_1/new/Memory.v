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
              BNZ = 12, JAL = 13, JMP = 14, JR = 15,

              PROG = 0, DAT = 64;
    reg [15:0] MEM [255:0];
    
    initial
    begin
        // Program Memory
        MEM[PROG + 0] = instr(LW,  0, 0, DAT);
        MEM[PROG + 1] = instr(LI,  1, 0, 1);
        MEM[PROG + 2] = instr(ADD, 2, 0, 1);
        MEM[PROG + 3] = instr(SW,  2, 0, DAT);
        MEM[PROG + 4] = instr(BNZ, 2, 0, PROG + 10);
        MEM[PROG + 5] = instr(LW,  0, 0, DAT + 1);
        MEM[PROG + 6] = instr(LI,  1, 0, 1);
        MEM[PROG + 7] = instr(ADD, 2, 0, 1);
        MEM[PROG + 8] = instr(SW,  2, 0, DAT + 1);
        MEM[PROG + 9] = instr(LW, 14, 0, DAT + 1);
        MEM[PROG +10] = instr(LW, 15, 0, DAT);
        MEM[PROG +11] = instr(JMP, 0, 0, PROG);

        // Data Memory
        MEM[DAT + 0] = 0;
        MEM[DAT + 1] = 0;
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
