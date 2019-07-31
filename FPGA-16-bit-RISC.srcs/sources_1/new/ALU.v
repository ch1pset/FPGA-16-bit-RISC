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


module ALU(
    input [15:0] A, B,
    input [2:0] OP,
    output [15:0] Data
    );
    
    wire [15:0] mux [7:0];

    assign mux[0] = A + B;
    assign mux[1] = A - B;
    assign mux[2] = A & B;
    assign mux[3] = A | B;
    assign mux[4] = A ^ B;
    assign mux[5] = ~A;
    assign mux[6] = A << 1;
    assign mux[7] = A >> 1;

    assign Data = mux[OP];
endmodule
