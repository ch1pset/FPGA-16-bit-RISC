`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2019 06:14:03 PM
// Design Name: 
// Module Name: Instruction_Register
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


module Instruction_Register(clk, INSTR, in, IR_ld);
input [15:0] in;
input clk, IR_ld;
output reg [15:0] INSTR;
always @ (posedge clk)
begin
if (IR_ld==1) INSTR<=in;
end
endmodule
