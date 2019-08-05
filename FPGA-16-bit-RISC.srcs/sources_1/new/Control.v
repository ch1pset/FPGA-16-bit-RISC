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
    output reg Offset_sel,
    output reg IR_load,
    output reg Mem_sel, Mem_read, Mem_write
    );
    parameter   ADD = 0,  SUB = 1,  AND = 2,  OR  = 3,
                XOR = 4,  NOT = 5,  SLA = 6,  SRA = 7,
                LI  = 8,  LW  = 9,  SW  = 10, BIZ = 11,
                BNZ = 12, JAL = 13, JMP = 14, JR  = 15;

    parameter   S_idle  = 0, 
                S_fet0  = 1, S_fet1  = 2,
                S_dec   = 3,
                S_Rd_w  = 4, S_Mem_w = 5, S_PC_ld = 6;

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
        Rs_sel = 0;
        Rd_write = 0;   Rs_read = 0;    Rt_read = 0;
        Mem_read = 0;   Mem_write = 0;
        PC_load = 0;    PC_clr = 0;     PC_inc = 0;
        Offset_sel = 0;
        IR_load = 0;


        case(state)
        S_idle: state = S_fet0;

        S_fet0: begin
            Mem_sel = M_PC;
            Mem_read = 1;
            state = S_fet1;
        end

        S_fet1: begin
            IR_load = 1;
            PC_inc = 1;
            state = S_dec;
        end

        S_dec: begin
            case(OP_code)
            ADD, SUB, AND, OR, XOR: begin
                Rd_sel = Rd_ALU;
                Rs_read = 1;
                Rt_read = 1;
                state = S_Rd_w;
            end

            NOT, SLA, SRA: begin
                Rd_sel = Rd_ALU;
                Rs_read = 1;
                state = S_Rd_w;
            end

            LI: begin
                Rd_sel = Rd_IMM;
                state = S_Rd_w;
            end

            LW: begin
                Mem_sel = M_addr;
                Rd_sel = Rd_MEM;
                state = S_Rd_w;
            end

            SW: begin
                Mem_sel = M_addr;
                Rs_sel = 1;
                Rs_read = 1;
                state = S_Mem_w;
            end

            BIZ, BNZ: begin
                Rs_sel = 1;
                Rs_read = 1;
                state = S_PC_ld;
            end

            JAL: begin
                Rd_sel = Rd_PC;
                state = S_Rd_w;
            end

            JMP: state = S_PC_ld;

            JR: begin
                Rs_read = 1;
                Offset_sel = 1;
                state = S_PC_ld;
            end
            endcase
        end

        S_Rd_w: begin
            Rd_write = 1;
            case(OP_code)
            JAL:     state = S_PC_ld;
            default: state = S_idle;
            endcase
        end

        S_Mem_w: begin
            Mem_write = 1;
            state = S_idle;
        end

        S_PC_ld: begin
            case(OP_code)
            BIZ:     PC_load = Rs_zero;
            BNZ:     PC_load = ~Rs_zero;
            default: PC_load = 1;
            endcase
            state = S_idle;
        end
        endcase
    end
endmodule
