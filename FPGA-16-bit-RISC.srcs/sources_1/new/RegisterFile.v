`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/31/2019 11:07:53 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input [15:0] dest_data,
    input [3:0] dest_addr,
    input dest_write,
    input [3:0] src_addr,
    input src_read,
    input [3:0] tar_addr,
    input tar_read,
    input clk,
    output reg [15:0] src_data, tar_data,
    output reg src_zero
    );
    reg [15:0] REG [15:0];
    always@(posedge clk)
    begin
        if(dest_write) REG[dest_addr] = dest_data;

        if(src_read) src_data = REG[src_addr];

        if(tar_read) tar_data = REG[tar_addr];

        src_zero = (src_data == 0);
    end
endmodule
