`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2019 10:29:02 AM
// Design Name: 
// Module Name: ALU
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


module ALU (
    input [15:0] A, B,
    input [2:0] OP,
    output reg [15:0] Data = 0
    );
    parameter   ADD = 0, SUB = 1, AND = 2, OR  = 3,
                XOR = 4, NOT = 5, SHL = 6, SHR = 7;
    always@(*)
    begin
        case(OP)
        ADD:   Data = A + B;
        SUB:   Data = A - B;
        AND:   Data = A & B;
        OR:    Data = A | B;
        XOR:   Data = A ^ B;
        NOT:   Data = ~A;
        SHL:   Data = A << 1;
        SHR:   Data = A >> 1;
        endcase
    end
endmodule
