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


module RegisterFile #(parameter DATA_WIDTH=16, ADDR_WIDTH=4)(
    input [15:0] dest_data,
    input [3:0] dest_addr,
    input dest_write,
    input [3:0] src_addr,
    input src_read,
    input [3:0] tar_addr,
    input tar_read,
    input clk,
    output reg [15:0] src_data = 0, tar_data = 0,
    output src_zero
    );
    reg [DATA_WIDTH-1:0] REG [(2**ADDR_WIDTH)-1:0];
    integer i = 0;
//    initial for(i = 0; i < (2**ADDR_WIDTH); i = i + 1) REG[i] = 0;

    assign src_zero = (src_data == 0);

    always@(posedge clk)
    begin
        if(dest_write) REG[dest_addr] <= dest_data;

        if(src_read) src_data <= REG[src_addr];

        if(tar_read) tar_data <= REG[tar_addr];
    end
endmodule
