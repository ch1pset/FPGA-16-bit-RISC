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
    input [15:0] w_data,
    input [3:0] w_addr,
    input w_wr,
    input [3:0] Rp_addr,
    input Rp_rd,
    input [3:0] Rq_addr,
    input Rq_rd,
    input clk,
    output reg [15:0] Rp_data, Rq_data
    );
    reg [15:0] REG [15:0];
    always@(posedge clk)
    begin
        if(w_wr) REG[w_addr] = w_data;

        if(Rp_rd) Rp_data = REG[Rp_addr];

        if(Rq_rd) Rq_data = REG[Rq_addr];

        
    end
endmodule
