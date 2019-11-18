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
    input [7:0] pc_in,
    input [7:0] offset,
    output [7:0] pc_out
    );
    assign pc_out = pc_in + offset;
endmodule
