`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2019 10:32:50 PM
// Design Name: 
// Module Name: RISC_16bit
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


module RISC_16bit(
    input CLK100MHZ, BTNC,
    output reg [15:0] LED,
    output [7:0] CA, AN
    );
    parameter DISREG0 = 4'hf, DISREG1 = 4'he;

    wire clk;
    wire rst = BTNC;

    reg [31:0] disp_data;

    wire [15:0] Instr_mux, Instr_out;
    wire [15:0] Mem_out, Mem_data;
    wire [15:0] Rs_out, Rt_out;
    wire [15:0] RF_mux;
    wire [15:0] ALU_out;
    wire Rs_zero;
    wire [7:0] PC_addr, Rd_data;
    wire [7:0] Mem_addr;
    wire [3:0] Rd_addr, Rs_addr, Rt_addr;
    wire [2:0] ALU_sel;
    wire [1:0] Rd_sel;
    wire Rs_sel;
    wire Rd_write, Rs_read, Rt_read;
    wire PC_load, PC_clr, PC_inc;
    wire IR_load, IR_sel;
    wire Mem_sel, Mem_read, Mem_write;

    SlowClock #(2, 10) SCLK(CLK100MHZ, clk);

    Controller CON(
        Instr_out,
        Rs_zero, clk, rst,
        Rd_data,
        Rd_addr, Rs_addr, Rt_addr,
        ALU_sel,
        Rd_sel, Rs_sel,
        Rd_write, Rs_read, Rt_read,
        PC_load, PC_clr, PC_inc,
        IR_sel, IR_load,
        Mem_sel, Mem_read, Mem_write
    );
    Program_Counter PC(
        (PC_addr + Instr_out[7:0]),
        PC_load, PC_clr, PC_inc,
        clk,
        PC_addr
    );
    Instruction_Register IR(
        Instr_mux, IR_load, 
        clk, 
        Instr_out
    );
    RegisterFile RF(
        RF_mux,
        Rd_addr, Rd_write,
        Rs_addr, Rs_read,
        Rt_addr, Rt_read,
        clk,
        Rs_out, Rt_out,
        Rs_zero
    );
    ALU AU(
        Rs_out, Rt_out,
        ALU_sel, ALU_out
    );
    Memory RAM (
        Mem_addr, Mem_data,
        Mem_read, Mem_write,
        clk,
        Mem_out
    );
    Mux_4 #(16) RDSEL(
        {8'h00, (PC_addr)}, {{9{Rd_data[7]}}, Rd_data[6:0]}, Mem_out, ALU_out,
        Rd_sel,
        RF_mux
    );
    Mux_2 #(16) IR_Mux(
        Rs_out, Mem_out,
        IR_sel,
        Instr_mux
    );
    Mux_2 #(8) ADDR_Mux(
        Mem_out[7:0], PC_addr,
        Mem_sel,
        Mem_addr
    );

endmodule
