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
    parameter DISREG = 4'hf;

    wire clk;
    wire rst = BTNC;

    reg [31:0] disp_data;

    wire [15:0] Mem_out, Mem_data;
    wire Rs_zero;
    wire [7:0] PC_addr, Offset_out, Rd_data;
    wire [3:0] Rd_addr, Rs_addr, Rt_addr;
    wire [2:0] ALU_sel;
    wire [1:0] Rd_sel;
    wire Rs_sel;
    wire Rd_write, Rs_read, Rt_read;
    wire PC_load, PC_clr, PC_inc;
    wire Offset_sel;
    wire IR_load;
    wire Mem_sel, Mem_read, Mem_write;

    SlowClock #(2, 100) SCLK(CLK100MHZ, clk);

    Display DU(
        disp_data,
        CLK100MHZ,
        1,
        CA, AN
    );

    ControlUnit CU(
        Mem_out, Mem_data,
        Rs_zero, clk, rst,
        Rd_data, PC_addr,
        ALU_sel, Rd_sel, Rs_sel,
        Rd_addr, Rs_addr, Rt_addr,
        Rd_write, Rs_read, Rt_read,
        Mem_sel, Mem_read, Mem_write
    );
    ProcessorUnit PU(
        Mem_out,
        Rd_data, PC_addr,
        ALU_sel,
        Rd_sel,
        Rd_addr, Rs_addr, Rt_addr,
        Rd_write, Rs_read, Rt_read,
        clk,
        Mem_data,
        Rs_zero
    );
    MemoryUnit MU(
        Mem_data,
        PC_addr, Mem_out[7:0],
        Mem_sel, Mem_read, Mem_write,
        clk,
        Mem_out
    );

    always@(posedge clk)
    begin
        LED = Rd_addr;
        case(Rd_addr)
            DISREG: begin
                if(Rd_write == 1)
                    disp_data[15:0] = Mem_out;
            end
        endcase
    end
endmodule

module ControlUnit (
    input [15:0] Mem_out,
    input [15:0] Rs_out,
    input Rs_zero, clk, rst,
    output [7:0] Rd_data, PC_addr,
    output [2:0] ALU_sel,
    output [1:0] Rd_sel,
    output Rs_sel,
    output [3:0] Rd_addr, Rs_addr, Rt_addr,
    output Rd_write, Rs_read, Rt_read,
    output Mem_sel, Mem_read, Mem_write
    );
    wire [15:0] Instr_mux, Instr_out;
    wire [7:0] Offset_out;
    wire PC_load, PC_clr, PC_inc;
    wire IR_sel, IR_load;
    
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
    Mux_2 #(16) IR_Mux(
        Rs_out, Mem_out,
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
    Mux_4 #(16) RDSEL(
        {8'h00, (PC_addr)}, {8'h00, Rd_data}, Instr, ALU_out,
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
    Mux_2 #(8) ADDR_Mux(
        Mem_addr, PC_addr,
        Mux_addr_sel,
        Mux_addr
    );
endmodule
