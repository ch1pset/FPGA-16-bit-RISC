`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2019 09:52:54 AM
// Design Name: 
// Module Name: Control
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


module Controller (
    input [15:0] instr,
    input RF_Rp_z,
    output PC_load,
    output PC_cur_ir,
    output PC_inc,
    output IR_load,
    output [7:0] D_addr,
    output D_read, D_write,
    output [7:0] RF_w_data,
    output [1:0] RF_sel,
    output [3:0] RF_w_addr,
    output RF_write,
    output [3:0] RF_Rp_addr,
    output RF_Rp_read,
    output [3:0] RF_Rq_addr,
    output RF_Rq_read,
    output [2:0] ALU_sel
    );
endmodule
