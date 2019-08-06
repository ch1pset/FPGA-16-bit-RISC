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
    wire [7:0] offset, pc, bg, sm;
    assign pc = instr_ptr - 1;
    wire sign = (offset_addr > pc);
    Mux_2 #(8) set_bg(offset_addr, pc, sign, bg);
    Mux_2 #(8) set_sm(pc, offset_addr, sign, sm);
    assign offset = bg - sm;
    Mux_2 #(8) shift_mux((pc + offset), (pc - offset), sign,   instr_off_ptr);
endmodule
