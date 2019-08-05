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

module Mux16_4x1(
    input [15:0] bus [3:0],
    input [1:0] sel,
    output [15:0] dout
    );
    wire [15:0] sign_extend;
    assign sign_extend[15] = bus[2][7];
    assign sign_extend[14:7] = 8'h00;
    assign sign_extend[6:0] = (~bus[2][6:0]) + 1;

    Mux #(16, 4) M0({bus[3], sign_extend, bus[1], bus[0]}, sel, dout);
endmodule

module Mux(bus, sel, dout);
    parameter WIDTH = 8, SIZE = 16;

    input [WIDTH-1:0] bus [SIZE-1:0];
    input [SIZE/2-1:0] sel;
    output [WIDTH-1:0] dout;

    assign dout = bus[sel];
endmodule
