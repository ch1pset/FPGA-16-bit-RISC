`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2019 09:02:18 PM
// Design Name: 
// Module Name: tb_Controller
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


module tb_Controller( );
    reg [15:0] Instr;
    reg Rs_zero = 0, clk = 1, rst = 0;
    wire [7:0] Rd_data;
    wire [2:0] state_probe;
    wire [3:0] Rd_addr, Rs_addr, Rt_addr, Opcode;
    wire [2:0] ALU_sel;
    wire [1:0] Rd_sel;
    wire Rs_sel;
    wire Rd_write, Rs_read, Rt_read;
    wire PC_load, PC_clr, PC_inc;
    wire IR_sel, IR_load;
    wire Mem_sel, Mem_read, Mem_write;

    wire [15:0] Instr_mux, Instr_out;
    wire [7:0] Offset_out, PC_addr;

    assign Opcode = UUT1.OP_code;
    assign state_probe = UUT1.state;
    
    Controller UUT1(
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
        Rs_out, Instr,
        IR_sel,
        Instr_mux
    );

    initial
    begin
        Instr = 16'h0201;
        #1 rst = 1;
        nextInstr(16'h2201);
        toggleRst();
        nextInstr(16'h5300);
        toggleRst();
        nextInstr(16'h6300);
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
        toggleRst();        
        #320 $finish;
    end

    always #1 clk = ~clk;

    task nextInstr;
    input [15:0] word;
    begin
        #14 Instr = word;
    end
    endtask

    task toggleRst;
    begin
        #1 rst = 0;
        #1 rst = 1;
    end
    endtask

endmodule
