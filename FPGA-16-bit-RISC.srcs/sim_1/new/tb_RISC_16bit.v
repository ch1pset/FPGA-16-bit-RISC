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
    parameter   //Instruction Set
    ADD = 0 , SUB = 1 ,
    AND = 2 , OR  = 3 , XOR = 4 ,
    NOT = 5 , SLA = 6 , SRA = 7 ,
    LI  = 8 , LW  = 9 , SW  = 10,
    BIZ = 11, BNZ = 12,
    JAL = 13, JMP = 14, JR  = 15,

    Rd = (1 << 8), Rs = (1 << 4), Rt = 1, Byte = 1;

    reg clk = 0, rst = 0;
    
    RISC_16bit UUT1(
        clk, rst
    );
    wire Mem_read = UUT1.Mem_read;
    wire [15:0] Instr = UUT1.CU.IR.INSTR;
    wire IR_load = UUT1.CU.IR_load;
    wire [15:0] RF_mux = UUT1.PU.RF_mux;
    wire [7:0] Rd_data = UUT1.CU.CON.Rd_data;
    wire [1:0] Rd_sel = UUT1.CU.Rd_sel;
    wire [3:0] Rd_addr = UUT1.Rd_addr,
               Rs_addr = UUT1.Rs_addr,
               Rt_addr = UUT1.Rt_addr;
               
    wire [15:0] Rd_probe = UUT1.PU.RF.REG[Rd_addr],
                Rs_probe = UUT1.PU.RF.REG[Rs_addr],
                Rt_probe = UUT1.PU.RF.REG[Rt_addr];

    wire [3:0] Opcode = UUT1.CU.Instr_out[15:12];
    wire [2:0] state = UUT1.CU.CON.state;

    wire Rs_zero = UUT1.Rs_zero;
    wire PC_load = UUT1.CU.PC_load;
    wire PC_inc = UUT1.CU.PC_inc;
    wire [7:0] PC = UUT1.CU.PC_addr;
    wire [7:0] Next = UUT1.CU.Instr_out[7:0];
    wire [7:0] Offset = UUT1.CU.Offset_out;

    initial
    begin
        UUT1.MU.RAM.MEM[0]  = instr( LI,   0,   0, 8'h05     );
        UUT1.MU.RAM.MEM[1]  = instr( LI,   1,   0, 8'h07     );
        UUT1.MU.RAM.MEM[2]  = instr( ADD,  2,   0, 1         );
        UUT1.MU.RAM.MEM[3]  = instr( SUB,  3,   1, 0         );
        UUT1.MU.RAM.MEM[4]  = instr( LW,   6,   0, 8'h08     );
        UUT1.MU.RAM.MEM[5]  = instr( SW,   6,   0, 8'h08     );
        UUT1.MU.RAM.MEM[6]  = instr( BIZ,  6,   0, 8'h09     );
        UUT1.MU.RAM.MEM[7]  = instr( JMP,  0,   0, 8'h11     );
        UUT1.MU.RAM.MEM[8]  = 0;
        UUT1.MU.RAM.MEM[9]  = instr( JAL,  15,  0, 8'h0d     );
        UUT1.MU.RAM.MEM[10] = instr( BNZ,  6,   0, 8'h09     );
        UUT1.MU.RAM.MEM[11] = instr( SLA,  6,   3, 0         );
        UUT1.MU.RAM.MEM[12] = instr( JMP,  0,   0, 8'h00     );
        UUT1.MU.RAM.MEM[13] = instr( JR,   0,   15,0         );

        #800 $finish;
    end

    always #1 clk = ~clk;

    function [15:0] instr;
    input [3:0] op, rd, rs;
    input [7:0] rt;
    instr = (op << 12) + (rd << 8) + (rs << 4) + rt;
    endfunction

endmodule
