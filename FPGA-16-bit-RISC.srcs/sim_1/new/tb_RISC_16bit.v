`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2019 03:12:33 PM
// Design Name: 
// Module Name: tb_RISC_16bit
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


module tb_RISC_16bit( );
    reg [15:0] Instr = 0, Rs_out = 0;
    reg Rs_zero = 0, clk = 1, rst = 0;
    wire [7:0] Rd_data, PC_addr;
    wire [3:0] Rd_addr, Rs_addr, Rt_addr, Opcode;
    wire [2:0] ALU_sel;
    wire [1:0] Rd_sel;
    wire Rs_sel;
    wire Rd_write, Rs_read, Rt_read;
    wire Mem_sel, Mem_read, Mem_write;

    assign Opcode = Instr[15:12];
    
    ControlUnit UUT1(
        Instr, Rs_out,
        Rs_zero, clk, rst,
        Rd_data, PC_addr,
        ALU_sel, Rd_sel, Rs_sel,
        Rd_addr, Rs_addr, Rt_addr,
        Rd_write, Rs_read, Rt_read,
        Mem_sel, Mem_read, Mem_write
    );

    initial
    begin
        Instr = 16'h0201;
        #1 rst = 1;
        nextInstr(16'h1201);
        toggleRst();
        nextInstr(16'h2201);
        toggleRst();
        nextInstr(16'h3201);
        toggleRst();
        nextInstr(16'h4201);
        toggleRst();
        nextInstr(16'h5300);
        toggleRst();
        nextInstr(16'h6300);
        toggleRst();
        nextInstr(16'h7300);
        toggleRst();
        nextInstr(16'h84ab);
        toggleRst();
        nextInstr(16'h94a0);
        toggleRst();
        nextInstr(16'ha5a0);
        toggleRst();
        nextInstr(16'hb501);
        toggleRst();
        nextInstr(16'hc501);
        toggleRst();
        nextInstr(16'hd6a0);
        toggleRst();
        nextInstr(16'he0a0);
        toggleRst();
        nextInstr(16'hf0a0);        
        #320 $finish;
    end

    always #1 clk = ~clk;

    task nextInstr;
    input [15:0] word;
    begin
        #24 Instr = word;
    end
    endtask

    task toggleRst;
    begin
        #1 rst = 0;
        #1 rst = 1;
    end
    endtask

endmodule
