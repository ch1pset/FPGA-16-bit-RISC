`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/03/2019 02:32:55 PM
// Design Name: 
// Module Name: Offset
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


module Offset(
    input [7:0] instr_ptr,
    input [7:0] offset,
    output [7:0] instr_off_ptr
    );
    wire [7:0] pos, neg;
    assign pos = instr_ptr + offset[6:0] - 1;
    assign neg = instr_ptr - offset[6:0] - 1;
    assign instr_off_ptr = offset[7] ? neg : pos;
endmodule
