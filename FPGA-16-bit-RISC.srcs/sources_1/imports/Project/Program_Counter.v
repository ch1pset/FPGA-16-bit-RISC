`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2019 06:31:50 PM
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(in, PC_ld, PC_clr, PC_inc, clk, count);
    input [7:0] in;
    input clk, PC_ld, PC_clr, PC_inc;
    output reg [7:0] count = 8'h00;

    always@(posedge clk)
    begin
        if (PC_clr==1) count = 8'h00;
        else if (PC_inc==1) count = count+1;
        else if (PC_ld==1) count = in;
    end

endmodule
