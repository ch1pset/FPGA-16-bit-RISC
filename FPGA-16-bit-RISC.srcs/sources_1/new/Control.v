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
    input Rs_zero, clk, rst,
    output [7:0] Rd_data,
    output [3:0] Rd_addr, Rs_addr, Rt_addr,
    output [2:0] ALU_sel,
    output reg [1:0] Rd_sel = 0,
    output reg Rs_sel = 0,
    output reg Rd_write = 0, Rs_read = 0, Rt_read = 0,
    output reg PC_load = 0, PC_clr = 0, PC_inc = 0,
    output reg IR_sel = 0, IR_load = 0,
    output reg Mem_sel = 0, Mem_read = 0, Mem_write = 0
    );
    parameter   //Opcodes
                ADD     = 0, SUB    = 1,  AND       = 2,  OR    = 3,
                XOR     = 4, NOT    = 5,  SLA       = 6,  SRA   = 7,
                LI      = 8, LW     = 9,  SW        = 10, BIZ   = 11,
                BNZ     = 12,JAL    = 13, JMP       = 14, JR    = 15,
                //States
                S_start  = 0, //Idle state
                S_fet0  = 1, S_fet1  = 2, //fetch state
                S_dec   = 3, //decode state
                S_ex0   = 4, S_ex1   = 5, S_ex2     = 6, //execute state
                S_done  = 7, //done state
                //Rd_sel constants
                Rd_ALU  = 0, Rd_MEM  = 1, Rd_IMM    = 2, Rd_PC   = 3,
                //Rs_sel constants
                Rs_src  = 0, Rs_dest = 1,
                //IR_sel constants
                IR_mem  = 0, IR_rs   = 1,
                //Mem_sel constants
                M_PC    = 0, M_addr  = 1;

    reg [2:0] state = 0;
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
        S_start: begin
            if(~rst) begin 
                state = S_fet0;
                Mem_sel = M_PC;
                IR_sel = IR_mem;
                Rs_sel = Rs_src;
                Mem_read = 1;
            end
        end

        S_fet0: begin
            state = S_fet1;
            IR_load = 1;
        end

        S_fet1: begin
            state = S_dec;
            PC_inc = 1;
        end

        S_dec: begin
            state = S_ex0;
            case(OP_code)
            ADD, SUB,
            AND, OR, XOR: Rd_sel = Rd_ALU;

            NOT, SLA, SRA: Rd_sel = Rd_ALU;

            LI: begin
                Rd_sel = Rd_IMM;
            end

            LW: begin
                Mem_sel = M_addr;
                Rd_sel = Rd_MEM;
            end

            SW, BIZ, BNZ: begin
                Mem_sel = M_addr;
                Rs_sel = Rs_dest;
            end

            JAL: Rd_sel = Rd_PC;
            // JMP: 
            JR: IR_sel = IR_rs;
            endcase
        end

        S_ex0: begin
            state = S_ex1;
            case(OP_code)
            ADD, SUB, 
            AND, OR, XOR: begin
                Rs_read = 1;
                Rt_read = 1;
                state = S_ex1;
            end
            NOT, SLA, SRA, 
            SW, BIZ, BNZ, JR: Rs_read = 1;

            LI, JAL: Rd_write = 1;

            LW: Mem_read = 1;

            JMP: IR_load = 1;
            endcase
        end

        S_ex1: begin
            state = S_ex2;
            case(OP_code)
            ADD, SUB, AND,
            OR, XOR, NOT,
            SLA, SRA, LW: Rd_write = 1;

            SW: Mem_write = 1;

            JAL, JMP: PC_load = 1;

            JR: IR_load = 1;
            endcase
        end

        S_ex2: begin
            state = S_done;
            case(OP_code)
            JR: PC_load = 1;

            BIZ: PC_load = Rs_zero;

            BNZ: PC_load = ~Rs_zero;
            endcase
        end

        S_done: begin
            state = S_start;
            Rd_sel = Rd_ALU;
            Rs_sel = Rs_src;
            Mem_sel = M_PC;
            IR_sel = IR_mem;
        end

        endcase
    end
endmodule
