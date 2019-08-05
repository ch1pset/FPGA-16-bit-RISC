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
    input clk
    );
    wire [15:0] Instr, Mem_data;
    wire Rs_zero;
    wire [7:0] PC_addr, Offset_out, Rd_data;
    wire [3:0] Rd_addr, Rs_addr, Rt_addr;
    wire [2:0] ALU_sel;
    wire [1:0] Rd_sel;
    wire Rd_write, Rs_read, Rt_read;
    wire PC_load, PC_clr, PC_inc;
    wire Offset_sel;
    wire IR_load;
    wire Mux_addr_sel, Mem_read, Mem_write;

    ControlUnit CU(
        Instr, Mem_data,
        Rs_zero, clk,
        Rd_data, PC_addr,
        ALU_sel, Rd_sel,
        Rd_addr, Rs_addr, Rt_addr,
        Rd_write, Rs_read, Rt_read,
        Mux_addr_sel, Mem_read, Mem_write
    );
    ProcessorUnit PU(
        Instr, Rd_data, PC_addr,
        ALU_sel, Rd_sel,
        Rd_addr, Rs_addr, Rt_addr,
        Rd_write, Rs_read, Rt_read,
        clk,
        Mem_data, Rs_zero
    );
    MemoryUnit MU(
        Mem_data,
        PC_addr, Instr[7:0],
        Mux_addr_sel, Mem_read, Mem_write,
        clk,
        Instr
    );

endmodule

module ControlUnit (
    input [15:0] Mem_out,
    input [15:0] Rs_out,
    input Rs_zero, clk,
    output [7:0] Rd_data, PC_addr,
    output [2:0] ALU_sel,
    output [1:0] Rd_sel,
    output [3:0] Rd_addr, Rs_addr, Rt_addr,
    output Rd_write, Rs_read, Rt_read,
    output Mux_addr_sel, Mem_read, Mem_write
    );
    wire [15:0] Instr_mux, Instr_out;
    wire [7:0] Offset_out;
    wire PC_load, PC_clr, PC_inc;
    wire IR_sel, IR_load;
    
    Controller CON(
        Instr_out, Rs_zero, clk,
        Rd_data,
        Rd_addr, Rs_addr, Rt_addr,
        ALU_sel, Rd_sel,
        Rd_write, Rs_read, Rt_read,
        PC_load, PC_clr, PC_inc,
        IR_sel, IR_load,
        Mux_addr_sel, Mem_read, Mem_write
    );
    Program_Counter PC(
        Offset_out,
        PC_load, PC_clr, PC_inc,
        clk,
        PC_addr
    );
    Offset OFF(
        PC_addr, Instr_out[7:0],
        Offset_out
    );
    Instruction_Register IR(
        Instr_mux, IR_load, 
        clk, 
        Instr_out
    );
    Mux #(16, 2) IR_Mux(
        {Rs_out, Mem_out},
        IR_sel,
        Instr_mux
    );
endmodule

module ProcessorUnit (
    input [15:0] Instr,
    input [7:0] Rd_data, PC_addr,
    input [2:0] ALU_sel,
    input [1:0] Rd_sel,
    input [3:0] Rd_addr, Rs_addr, Rt_addr,
    input Rd_write, Rs_read, Rt_read,
    input clk,
    output [15:0] Rs_out,
    output Rs_zero
    );
    wire [15:0] RF_mux, Rt_out, ALU_out;
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
    Mux16_4x1 RF_Mux(
        {PC_addr - 1, Rd_data, Instr, ALU_out},
        Rd_sel,
        RF_mux
    );
endmodule

module MemoryUnit (
    input [15:0] Mem_data,
    input [7:0] PC_addr, Mem_addr,
    input Mux_addr_sel,  Mem_read, Mem_write, clk,
    output [15:0] Mem_out
    );
    wire [7:0] Mux_addr;
    Memory RAM (
        Mux_addr, Mem_data,
        Mem_read, Mem_write,
        clk,
        Mem_out
    );
    Mux #(8, 2) ADDR_Mux(
        {Mem_addr, PC_addr},
        Mux_addr_sel,
        Mux_addr
    );
endmodule
