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

module Mux_4 #(parameter WIDTH=8) (
    input [WIDTH-1:0] bus3, bus2, bus1, bus0,
    input [1:0] sel,
    output [WIDTH-1:0] dout
    );
    wire [WIDTH-1:0] mux [3:0];
    assign mux[0] = bus0,
           mux[1] = bus1,
           mux[2] = bus2,
           mux[3] = bus3;
    assign dout = mux[sel];
endmodule


module Mux_2 #(parameter WIDTH=8) (
    input [WIDTH-1:0] bus1, bus0,
    input sel,
    output [WIDTH-1:0] dout
    );

    assign dout = sel ? bus1 : bus0;
endmodule
