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
    input Rs_zero, clk,
    output [7:0] Rd_data,
    output [3:0] Rd_addr, Rs_addr, Rt_addr,
    output [2:0] ALU_sel,
    output reg [1:0] Rd_sel,
    output reg Rd_write, Rs_read, Rt_read,
    output reg PC_load, PC_clr, PC_inc,
    output reg IR_sel, IR_load,
    output reg Mem_sel, Mem_read, Mem_write
    );
    parameter   ADD = 0,  SUB = 1,  AND = 2,  OR  = 3,
                XOR = 4,  NOT = 5,  SLA = 6,  SRA = 7,
                LI  = 8,  LW  = 9,  SW  = 10, BIZ = 11,
                BNZ = 12, JAL = 13, JMP = 14, JR  = 15;

    parameter   S_idle  = 0, //Idle state

                S_fet0  = 1, S_fet1  = 2, //fetch state
                
                S_dec   = 3, //decode state

                //Execute state
                S_ex_ALU0 = 4, S_ex_ALU1 = 5, S_ex_ALU2 = 6,
                S_ex_LI = 7,
                S_ex_LW0 = 8, S_ex_LW1 = 9,
                S_ex_SW0 = 10, S_ex_SW1 = 11,
                S_ex_BZ = 12, S_ex_BIZ = 13, S_ex_BNZ = 14,
                S_ex_JAL0 = 15, S_ex_JAL1 = 16,
                S_ex_JMP0 = 17, S_ex_JMP1 = 18,
                S_ex_JR0 = 19, S_ex_JR1 = 20, S_ex_JR2 = 21;

    parameter   Rd_ALU  = 0, Rd_MEM  = 1, Rd_IMM  = 2, Rd_PC   = 3;

    parameter   M_PC    = 0, M_addr  = 1;

    reg [3:0] state = 0;
    reg Rs_sel = 0;
    wire [3:0] OP_code;

    
    assign OP_code  = instr[15:12];
    assign ALU_sel  = instr[14:12];
    assign Rd_data  = instr[7:0];
    assign Rd_addr  = instr[11:8];
    assign Rs_addr  = Rs_sel ? Rd_addr : instr[7:4];
    assign Rt_addr  = instr[3:0];

    always@(posedge clk)
    begin
        Rd_write = 0;   Rs_read = 0;    Rt_read = 0;
        Mem_read = 0;   Mem_write = 0;
        PC_load = 0;    PC_clr = 0;     PC_inc = 0;
        IR_load = 0;

        case(state)
        S_idle: state = S_fet0;

        S_fet0: begin
            Mem_sel = M_PC;
            Mem_read = 1;
            state = S_fet1;
        end

        S_fet1: begin
            IR_sel = 0;
            Rs_sel = 0;
            IR_load = 1;
            PC_inc = 1;
            state = S_dec;
        end

        S_dec: begin
            case(OP_code)
            ADD, SUB, AND, OR, XOR: begin
                Rd_sel = Rd_ALU;
                state = S_ex_ALU0;
            end

            NOT, SLA, SRA: begin
                Rd_sel = Rd_ALU;
                state = S_ex_ALU1;
            end

            LI: begin
                Rd_sel = Rd_IMM;
                state = S_ex_LI;
            end

            LW: begin
                Mem_sel = M_addr;
                Rd_sel = Rd_MEM;
                state = S_ex_LW0;
            end

            SW: begin
                Mem_sel = M_addr;
                Rs_sel = 1;
                state = S_ex_SW0;
            end

            BIZ, BNZ: begin
                Rs_sel = 1;
                state = S_ex_BZ;
            end

            JAL: begin
                Rd_sel = Rd_PC;
                state = S_ex_JAL0;
            end

            JMP: begin
                state = S_ex_JMP0;
            end

            JR: begin
                Rs_read = 1;
                IR_sel = 1;
                state = S_ex_JR0;
            end
            endcase
        end

        S_ex_ALU0: begin
            Rs_read = 1;
            Rt_read = 1;
            state = S_ex_ALU2;
        end

        S_ex_ALU1: begin
            Rs_read = 1;
            state = S_ex_ALU2;
        end

        S_ex_ALU2: begin
            Rd_write = 1;
            state = S_idle;
        end

        S_ex_LI: begin
            Rd_write = 1;
            state = S_idle;
        end

        S_ex_LW0: begin
            Mem_read = 1;
            state = S_ex_LW1;
        end

        S_ex_LW1: begin
            Rd_write = 1;
            state = S_idle;
        end

        S_ex_SW0: begin
            Rs_read = 1;
            state = S_ex_SW1;
        end

        S_ex_SW1: begin
            Mem_write = 1;
            state = S_idle;
        end

        S_ex_BZ: begin
            Rs_read = 1;
            case(OP_code)
                BIZ: state = S_ex_BIZ;
                BNZ: state = S_ex_BNZ;
            endcase
        end

        S_ex_BIZ: begin
            PC_load = Rs_zero;
            state = S_idle;
        end

        S_ex_BNZ: begin
            PC_load = ~Rs_zero;
            state = S_idle;
        end

        S_ex_JAL0: begin
            Rd_write = 1;
            state = S_ex_JAL1;
        end

        S_ex_JAL1: begin
            PC_load = 1;
            state = S_idle;
        end

        S_ex_JMP0: begin
            IR_load = 1;
            state = S_ex_JMP1;
        end

        S_ex_JMP1: begin
            PC_load = 1;
            state = S_idle;
        end

        S_ex_JR0: begin
            Rs_read = 1;
            state = S_ex_JR1;
        end

        S_ex_JR1: begin
            IR_load = 1;
            state = S_ex_JR2;
        end

        S_ex_JR2: begin
            PC_load = 1;
            state = S_idle;
        end
        endcase
    end
endmodule
