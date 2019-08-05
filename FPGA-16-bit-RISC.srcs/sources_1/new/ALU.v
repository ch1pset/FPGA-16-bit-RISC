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


module ALU #(parameter
    ADD = 3'o0,
    SUB = 3'o1,
    AND = 3'o2,
    OR  = 3'o3,
    XOR = 3'o4,
    NOT = 3'o5,
    SHL = 3'o6,
    SHR = 3'o7) (
    input [15:0] A, B,
    input [2:0] OP,
    output reg [15:0] Data,
    output reg zero
    );
    always@(OP, A, B)
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
        if(A == 0) zero = 1;
        else zero = 0;
    end
endmodule
