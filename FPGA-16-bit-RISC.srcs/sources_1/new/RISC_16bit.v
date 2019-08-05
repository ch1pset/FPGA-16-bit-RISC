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
    wire [15:0] Instr_out, Mem_out, Rs_out, Rt_out, ALU_out, RF_Mux;
    wire Rs_zero;
    wire [7:0] Mem_addr, PC_addr, Mux_addr, Offset, Rd_data;
    wire [3:0] Rd_addr, Rs_addr, Rt_addr;
    wire [2:0] ALU_sel;
    wire [1:0] Rd_sel;
    wire Rd_write, Rs_read, Rt_read;
    wire PC_load, PC_clr, PC_inc;
    wire Offset_sel;
    wire IR_load;
    wire Mux_addr_sel, Mem_read, Mem_write;

    Controller CU(
        Instr_out, Rs_zero, clk,
        Mem_addr, Rd_data,
        Rd_addr, Rs_addr, Rt_addr,
        ALU_sel, Rd_sel,
        Rd_write, Rs_read, Rt_read,
        PC_load, PC_clr, PC_inc,
        Offset_sel,
        IR_load,
        Mux_addr_sel, Mem_read, Mem_write
    );
    ALU AU(
        Rs_out, Rt_out,
        ALU_sel, ALU_out
    );
    Instruction_Register IR(
        Mem_out, IR_load, 
        clk, 
        Instr_out
    );
    Mux #(16, 4) RegFileMux(
        {PC_addr, Rd_data, Mem_out, ALU_out},
        Rd_sel,
        RF_mux
    );
    RegisterFile RegFile(
        RF_mux,
        Rd_addr, Rd_write,
        Rs_addr, Rs_read,
        Rt_addr, Rt_read,
        clk,
        Rs_out, Rt_out,
        Rs_zero
    );
    Program_Counter PC(
        Offset,
        PC_load, PC_clr, PC_inc,
        clk,
        PC_addr
    );
    Offset OffCalc(
        PC_addr, Instr_out[7:0],
        Offset
    );
    Memory MEM(
        Mux_addr, Rs_out,
        Mem_read, Mem_write,
        clk,
        Mem_out
    );
    Mux #(8, 2) MemAddrSel(
        {Mem_addr, PC_addr},
        Mux_addr_sel,
        Mux_addr
    );

endmodule
