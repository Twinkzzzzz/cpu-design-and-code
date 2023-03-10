//I型指令
//lw 100011(6) + Rs(5) + Rt(5) + Imm16
//rw 101011(6) + Rs(5) + Rt(5) + Imm16
//beq 000100(6) + Rs(5) + Rt(5) + Addr16
//R型指令
//000000(6) + Rd(5) + Rs(5) + Rt(5) + empty(5) + func(6)
//func
//100000 alu_ctrl=3'b100; //+(jud)
//100001 alu_ctrl=3'b101; //+
//100010 alu_ctrl=3'b110; //-
//100100 alu_ctrl=3'b000; //&
//100101 alu_ctrl=3'b001; //|
//101010 alu_ctrl=3'b011; //^
//101011 alu_ctrl=3'b010; //A<B->1 else 0
//J型指令
//000010(6) + Addr26
`timescale 1ns/1ns
`include "alu.v"
`include "DM.v"
`include "MCU.v"
`include "pc.v"
`include "RF.v"
`include "IR.v"
`include "mux.v"
`include "sigExt.v"

module cpu; 
    reg clk;
    tri [31:0] Bus;
    wire [31:0] ctrl_wire;
    wire [31:0] data_wire [0:31];
    wire [5:0] alu_func_code;
    wire [4:0] RF_reg [0:10];
    reg [3:0] qq;
    reg [3:0] pp;
    integer i,j;
    CU my_CU(
        .clk(clk),
        .MCU_in(data_wire[0]),
        .ALU_Z(ctrl_wire[5]),
        .PCOeH(ctrl_wire[31]),
        .PCOeL(ctrl_wire[30]),
        .PCWr(ctrl_wire[29]),
        .IRWr(ctrl_wire[28]),
        .ImmOeH(ctrl_wire[27]),
        .ImmOeL(ctrl_wire[26]),
        .ExtSel(ctrl_wire[4:3]),
        .ALUOp(ctrl_wire[24:23]),
        //.ALUCtrl(ctrl_wire[22:20]),
        .AWr(ctrl_wire[19]),
        .BWr(ctrl_wire[18]),
        .ALUOe(ctrl_wire[17]),
        .RegOe(ctrl_wire[16]),
        .RegWr(ctrl_wire[15]),
        .RegSel(ctrl_wire[14:13]),
        .MARWr(ctrl_wire[12]),
        .MemRd(ctrl_wire[11]),
        .MemWr(ctrl_wire[10]),
        .MDRSrc(ctrl_wire[9]),
        .MDROe(ctrl_wire[8]),
        .MDRWr(ctrl_wire[7]),
        .MemOe(ctrl_wire[6])
    );

    IR my_IR(
        .clk(clk),
        .IRWr(ctrl_wire[28]),
        .IR_in(Bus),
        .IRout(data_wire[0])
        //.IRreg1(RF_reg[0]),
        //.IRreg2(RF_reg[1]),
        //.IRreg3(RF_reg[2]),
        //.IR_ALUfunc(alu_func_code)
    );

    sigext my_sigext(
        .in(data_wire[0]),
        .extsel(ctrl_wire[4:3]),
        .ImmOeH(ctrl_wire[27]),
        .ImmOeL(ctrl_wire[26]),
        .out4(Bus[31:28]),
        .out28(Bus[27:0])
    );

    mux_DM my_mux_DM(
        .clk(clk),
        .mux_in1(Bus),
        .mux_in2(data_wire[5]),
        .mux_ctrl(ctrl_wire[9]),
        .mux_out(data_wire[6])
    );
    
    MDR_out_ctrl my_MDR_out_ctrl(
        .MDROe(ctrl_wire[8]),
        .in(data_wire[4]),
        .out(Bus)
    );

    DM_out_ctrl my_DM_out_ctrl(
        .MemOe(ctrl_wire[6]),
        .in(data_wire[5]),
        .out(Bus)
    );

    MDR my_MDR(
        .clk(clk),
        .MDR_IN(data_wire[6]),
        .MDRWr(ctrl_wire[7]),
        .MDR_OUT(data_wire[4])
    );

    MAR my_MAR(
        .clk(clk),
        .MAR_IN(Bus),
        .MARWr(ctrl_wire[12]),
        .MAR_OUT(data_wire[3])
    );

    DM my_DM(
        .DM_addr(data_wire[3]),
        .DM_r(ctrl_wire[11]),
        .DM_w(ctrl_wire[10]),
        .data_write(data_wire[4]),
        .data_read(data_wire[5])
    );

    PC my_PC(
        .clk(clk),
        .PCWr(ctrl_wire[29]),
        .PCOeH(ctrl_wire[31]),
        .PCOeL(ctrl_wire[30]),
        .pcin(Bus),
        .pcoutl(Bus[27:0]),
        .pcouth(Bus[31:28])
    );

    mux_reg my_mux_reg(
        .mux_in1(data_wire[0][25:21]),
        .mux_in2(data_wire[0][20:16]),
        .mux_in3(data_wire[0][15:11]),
        .mux_ctrl(ctrl_wire[14:13]),
        .mux_out(RF_reg[3])
    );

    RF my_RF(
        .clk(clk),
        .RF_Wdata(Bus),
        .RF_reg(RF_reg[3]),
        .RF_Oe(ctrl_wire[16]),
        .RF_w(ctrl_wire[15]),
        .RF_Rdata(Bus)
    );

    ALU my_ALU(
        .A(data_wire[1]),
        .B(data_wire[2]),
        .alu_ctrl(ctrl_wire[22:20]),
        .ALUOe(ctrl_wire[17]),
        .alu_out_real(Bus),
        .Z(ctrl_wire[5])
    );

    ALUCU my_ALUCU(
        .alu_op(ctrl_wire[24:23]),
        .func_code(data_wire[0][5:0]),
        .alu_ctrl(ctrl_wire[22:20])
    );

    ALUsaveA my_ALUsaveA(
        .AWr(ctrl_wire[19]),
        .in(Bus),
        .out(data_wire[1])
    );

    ALUsaveB my_ALUsaveB(
        .BWr(ctrl_wire[18]),
        .in(Bus),
        .out(data_wire[2])
    );

    initial begin
        clk=0;
    end

    always begin
        if(my_CU.period==0) begin
            $display("----------");
            $write("reg[0-7]");
            for(i=0;i<=7;i=i+1) begin
                $write(my_RF.RF_memory[i]);
            end
            $display(" ");
            $write("dm[16-23]");
            for(i=16;i<=23;i=i+1) begin
                $write(my_DM.memory[i]);
            end
            $display(" ");
        end
        #8 clk=~clk;
        #8 clk=~clk;
    end

    initial begin
        #2100 $finish;
    end

    initial begin            
        $dumpfile("wave.vcd");
        $dumpvars(0,cpu);
    end 
endmodule