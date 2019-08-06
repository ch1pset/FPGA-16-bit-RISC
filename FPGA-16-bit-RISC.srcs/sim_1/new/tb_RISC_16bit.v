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
    ADD = (0 << 12), SUB = (1 << 12),
    AND = (2 << 12), OR = (3 << 12), XOR = (4 << 12),
    NOT = (5 << 12), SLA = (6 << 12), SRA = (7 << 12),
    LI = (8 << 12), LW = (9 << 12), SW = (10 << 12),
    BIZ = (11 << 12), BNZ = (12 << 12),
    JAL = (13 << 12), JMP = (14 << 12), JR = (15 << 12),

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
        UUT1.MU.RAM.MEM[0] = LI  + (Rd * 0)  + (Byte * 5);
        UUT1.MU.RAM.MEM[1] = LI  + (Rd * 1)  + (Byte * 7);
        UUT1.MU.RAM.MEM[2] = ADD + (Rd * 2)  + (Rs * 0)      + (Rt * 1);
        UUT1.MU.RAM.MEM[3] = SUB + (Rd * 3)  + (Rs * 1)      + (Rt * 0);
        UUT1.MU.RAM.MEM[4] = LW  + (Rd * 6)  + (Byte * 8);
        UUT1.MU.RAM.MEM[5] = SW  + (Rd * 6)  + (Byte * 8);
        UUT1.MU.RAM.MEM[6] = BIZ + (Rd * 6)  + (Byte * 9);
        UUT1.MU.RAM.MEM[7] = JMP + 0         + (Byte * 11);
        UUT1.MU.RAM.MEM[8] = 0;
        UUT1.MU.RAM.MEM[9] = JAL + (Rd * 15) + (Byte * 13);
        UUT1.MU.RAM.MEM[10]= BNZ + (Rd * 6)  + (Byte * 9);
        UUT1.MU.RAM.MEM[11]= SLA + (Rd * 6)  + 0;
        UUT1.MU.RAM.MEM[12]= JMP + 0         + 0;
        UUT1.MU.RAM.MEM[13]= JR  + 0         + (Rs * 15)    + 0;

        #400 $finish;
    end

    always #1 clk = ~clk;

    task toggleRst;
    begin
        #1 rst = 0;
        #1 rst = 1;
    end
    endtask

endmodule
