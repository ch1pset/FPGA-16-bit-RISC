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
    input [7:0] offset_addr,
    output [7:0] instr_off_ptr
    );
    wire [7:0] offset;
    wire sign = (offset_addr > instr_ptr);

    assign offset = sign ? 
        (offset_addr - instr_ptr): 
        (instr_ptr - offset_addr);

    assign instr_off_ptr = sign ?
        (instr_ptr + offset - 1):
        (instr_ptr - offset - 1);
endmodule
