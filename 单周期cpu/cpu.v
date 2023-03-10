/*
32位指令
1型：
00|5bit源寄存器编号|5bit源寄存器编号|5bit目标寄存器编号|空11bit|4bit操作码
操作码：
0000 源+源->目标
0001 源-源->目标
0010 源低16bit*源低16bit->目标32bit
0011 源32bit/源低16bit->目标低16bit
0100 源and源->目标
0101 源or源->目标
0110 源xor源->目标
0111 源=源->目标=1/源!=源->目标=0
1000 源<<源->目标
1001 源>>源->目标
2型：
01|5bit源寄存器编号|5bit目标寄存器编号|16bit地址/立即数|4bit操作码
操作码：
0000 目标=源->PC=16bit地址
0001 目标=源->PC=PC+立即数
0010 目标=源->PC=16bit地址内容
0011 目标=源->PC=PC+16bit地址内容
0111 源=立即数->目标=1/源!=立即数->目标=0
1000 DM[目标寄存器]=源寄存器
3型：
10|5bit寄存器号|空5bit|16bit地址/立即数|4bit操作码
操作码：
0000 寄存器数据+立即数
0001 寄存器数据-立即数
0010 寄存器数据*立即数
0011 寄存器32bit/立即数
0100 寄存器低16位and立即数
0101 寄存器低16位or立即数
0110 寄存器低16位xor立即数
1000 寄存器左移，位数=立即数
1001 寄存器右移，位数=立即数
1010 地址数据->寄存器
1011 立即数->寄存器
1100 寄存器数据->地址空间
1101 PC=寄存器内容
1110 PC=寄存器内容+立即数
4型：
11|空10bit|16bit地址/立即数|4bit操作码
操作码：
0000 PC=目标地址
0001 PC=PC+立即数
0010 PC=16bit地址内容
0011 PC=PC+16bit地址内容
*/
`timescale 1ns/1ns
`include "alu.v"
`include "mux.v"
`include "sigext.v"
`include "IM.v"
`include "DM.v"
`include "and_gate.v"
`include "MCU.v"
`include "PC.v"
`include "RF.v"

module cpu;
    reg clk;
    wire [31:0] inst;
    wire [31:0] RF_out1;
    wire [31:0] RF_out2;
    wire [31:0] ALU_out;
    wire [31:0] DM_out;
    wire [31:0] sigext_out;
    wire [15:0] PC_plus_out;
    wire [15:0] PC_assign_out;
    wire [15:0] PC_out;
    wire [15:0] mux_PCinput_out;
    wire [15:0] mux_imm_or_dm1_out;
    wire [15:0] mux_assign_PC_out;
    wire [15:0] mux_four_or_not_out;
    wire [15:0] mux_dm_addr_out;
    wire [31:0] mux_reg2_or_imm_out;
    wire [31:0] mux_RF_write_data_out;
    wire mux_if_alu_ctrl_pc_out;
    wire dm_addr_w;
    wire [4:0] mux_RF_in_out;
    wire PC_input_w,PC_input_real,imm_or_dm1_w,four_or_not_w,four_or_not_real,reg2_or_imm_w,cmp_for_leap_w,RF_write_w,DM_write_w,DM_read_w;
    wire [1:0] assign_PC_w;
    wire [1:0] RF_write_data_w;
    wire [1:0] reg_write_w;
    wire [3:0] ALU_ctrl_w;
    integer i;

    MCU my_MCU(
        .opt_code(inst[31:30]),
        .func_code(inst[3:0]),
        .clk(clk),
        .PC_input(PC_input_w),
        .imm_or_dm1(imm_or_dm1_w),
        .assign_PC(assign_PC_w),
        .four_or_not(four_or_not_w),
        .reg2_or_imm(reg2_or_imm_w),
        .RF_write_data_mux(RF_write_data_w),
        .cmp_for_leap(cmp_for_leap_w),
        .RF_write(RF_write_w),
        .DM_write(DM_write_w),
        .DM_read(DM_read_w),
        .reg_write_mux(reg_write_w),
        .ALU_ctrl(ALU_ctrl_w),
        .DM_addr_in(dm_addr_w)
    );

    IM my_IM(
        .addr(PC_out),
        .out_ins(inst)
    );

    DM my_DM(
        .addr(mux_dm_addr_out),
        .R(DM_read_w),
        .W(DM_write_w),
        .data_write(RF_out1),
        .data_read(DM_out)
    );

    ALU my_ALU(
        .func_code(ALU_ctrl_w),
        .alu_A(RF_out1),
        .alu_B(mux_reg2_or_imm_out),
        .alu_C(ALU_out)
    );

    alu_PC my_alu_PC(
        .recent_pc(PC_out),
        .leap(mux_four_or_not_out),
        .sum(PC_plus_out)
    );

    mux_PCinput my_mux_PCinput(
        .mux_in1(PC_plus_out),
        .mux_in2(mux_assign_PC_out),
        .mux_ctrl(PC_input_real),
        .mux_out(mux_PCinput_out)
    );

    mux_imm_or_dm1 my_mux_imm_or_dm1(
        .imm_in(inst[19:4]),
        .dm_in(DM_out),
        .mux_ctrl(imm_or_dm1_w),
        .mux_out(mux_imm_or_dm1_out)
    );

    mux_assign_PC my_mux_assign_PC(
        .imm_in(inst[19:4]),
        .dm_in(DM_out),
        .reg_in(RF_out1),
        .alu_in(ALU_out),
        .mux_ctrl(assign_PC_w),
        .mux_out(mux_assign_PC_out)
    );

    mux_four_or_not my_mux_four_or_not(
        .leap(mux_imm_or_dm1_out),
        .mux_ctrl(four_or_not_real),
        .mux_out(mux_four_or_not_out)
    );

    mux_reg2_or_imm my_mux_reg2_or_imm(
        .reg2(RF_out2),
        .imm(sigext_out),
        .mux_ctrl(reg2_or_imm_w),
        .mux_out(mux_reg2_or_imm_out)
    );
    
    mux_RF_write_data my_mux_RF_write_data(
        .alu_in(ALU_out),
        .imm_in(sigext_out),
        .dm_in(DM_out),
        .mux_ctrl(RF_write_data_w),
        .mux_out(mux_RF_write_data_out)
    );

    mux_if_alu_ctrl_pc my_mux_if_alu_ctrl_pc(
        .aluoutput(ALU_out),
        .mux_ctrl(cmp_for_leap_w),
        .mux_out(mux_if_alu_ctrl_pc_out)
    );

    mux_RF_in my_mux_RF_in(
        .ins1915(inst[19:15]),
        .ins2420(inst[24:20]),
        .ins2925(inst[29:25]),
        .mux_ctrl(reg_write_w),
        .mux_out(mux_RF_in_out)
    );

    mux_dm_addr my_mux_dm_addr(
        .imm_in(inst[19:4]),
        .reg_in(RF_out2[15:0]),
        .mux_ctrl(dm_addr_w),
        .mux_out(mux_dm_addr_out)
    );

    PC my_PC(
        .clk(clk),
        .in(mux_PCinput_out),
        .out(PC_out)
    );

    RF my_RF(
        .clk(clk),
        .write_data(mux_RF_write_data_out),
        .reg1(inst[29:25]),
        .reg2(inst[24:20]),
        .write_reg(mux_RF_in_out),
        .if_w(RF_write_w),
        .data1(RF_out1),
        .data2(RF_out2)
    );

    and_gate1 andgate_PCinput(
        .A(PC_input_w),
        .B(mux_if_alu_ctrl_pc_out),
        .C(PC_input_real)
    );

    and_gate2 andgate_four_or_not(
        .A(four_or_not_w),
        .B(mux_if_alu_ctrl_pc_out),
        .C(four_or_not_real)
    );

    sigext my_sigext(
        .data(inst[19:4]),
        .out(sigext_out)
    );

    initial clk = 0;

    always begin
        $display("-------------------------------PC=%d",my_PC.out);
        $write("reg[0-7]:");
        for(i=0;i<=7;i=i+1) begin
            $write(my_RF.memory[i]);
        end
        $display(" ");
        $write("DM[0-7]");
        for(i=0;i<=7;i=i+1) begin
            $write(my_DM.memory[i]);
        end
        $display(" ");
        #4 clk=~clk;
        #4 clk=~clk;
    end

    initial begin
        #200 $finish;
    end

    initial begin            
        $dumpfile("wave.vcd");
        $dumpvars(0,cpu);
    end
endmodule