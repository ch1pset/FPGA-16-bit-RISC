`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2019 11:29:31 AM
// Design Name: 
// Module Name: Mux
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


module Mux(bus, sel, dout);
    parameter WIDTH = 8, SIZE = 16;

    input [WIDTH-1:0] bus [SIZE-1:0];
    input [SIZE/2-1:0] sel;
    output [WIDTH-1:0] dout;

    assign dout = bus[sel];
endmodule

