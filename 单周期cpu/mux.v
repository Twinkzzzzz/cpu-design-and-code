module mux_PCinput(input [15:0] mux_in1,input [15:0] mux_in2,input mux_ctrl,output [15:0] mux_out);
    reg [15:0] mux_out;
    always@(*)begin
        case(mux_ctrl)
            1'b0:mux_out=mux_in1;
            1'b1:mux_out=mux_in2;
        endcase
    end
endmodule

module mux_imm_or_dm1(input [15:0] imm_in,input [31:0] dm_in,input mux_ctrl,output [15:0] mux_out); //for PC
    reg [15:0] mux_out;
    always@(*)begin
        case(mux_ctrl)
            1'b0:mux_out=imm_in;
            1'b1:mux_out=dm_in[15:0];
        endcase
    end
endmodule

module mux_assign_PC(
    input [15:0] imm_in,
    input [31:0] dm_in,
    input [31:0] reg_in,
    input [31:0] alu_in,
    input [1:0] mux_ctrl,
    output [15:0] mux_out); //for PC

    reg [15:0] mux_out;
    always@(*)begin
        case(mux_ctrl)
            2'b00:mux_out=imm_in;
            2'b01:mux_out=dm_in[15:0];
            2'b10:mux_out=reg_in[15:0];
            2'b11:mux_out=alu_in[15:0];
        endcase
    end
endmodule

module mux_four_or_not(input [15:0] leap,input mux_ctrl,output [15:0] mux_out); //for PC
    reg [15:0] mux_out;
    always@(*)begin
        case(mux_ctrl)
            1'b0:mux_out=16'b0000000000000001;
            1'b1:mux_out=leap[15:0];
        endcase
    end
endmodule

module mux_reg2_or_imm(input [31:0] reg2,input [31:0] imm,input mux_ctrl,output [31:0] mux_out); //for RF output (alu input)
    reg [31:0] mux_out;
    always @(*) begin
        case(mux_ctrl)
            1'b0:mux_out=reg2;
            1'b1:mux_out=imm;
        endcase
    end
endmodule

module mux_RF_write_data (input [31:0] alu_in,input [31:0] imm_in,input [31:0] dm_in, input [1:0] mux_ctrl,output [31:0] mux_out); //for RF input
    reg [31:0] mux_out;
    always @(*) begin
        case(mux_ctrl)
            2'b00:mux_out=alu_in;
            2'b01:mux_out=alu_in;
            2'b10:mux_out=imm_in;
            2'b11:mux_out=dm_in;
        endcase
    end
endmodule
/*
module mux_imm_or_dm3(input [31:0] imm_in,input [31:0] dm_in,input mux_ctrl,output [31:0] mux_out); //for RF input
    reg [31:0] mux_out;
    always@(*)begin
        case(mux_ctrl)
            1'b0:mux_out=imm_in;
            1'b1:mux_out=dm_in;
        endcase
    end
endmodule
*/
module mux_if_alu_ctrl_pc (input [31:0] aluoutput,input mux_ctrl,output mux_out);
    reg mux_out;
    always@(*)begin
        case(mux_ctrl)
            1'b0:mux_out=1'b1;
            1'b1:mux_out=aluoutput[0];
        endcase
    end
endmodule

module mux_RF_in (input [4:0] ins1915,input [4:0] ins2420,input[4:0] ins2925,input [1:0] mux_ctrl,output [4:0] mux_out);
    reg [4:0] mux_out;
    always@(*)begin
        case(mux_ctrl)
            2'b00:mux_out=ins1915;
            2'b01:mux_out=ins1915;
            2'b10:mux_out=ins2420;
            2'b11:mux_out=ins2925;
        endcase
    end
endmodule

module mux_dm_addr(input[15:0] imm_in, input[15:0] reg_in, input mux_ctrl, output[15:0] mux_out);
    reg [15:0] mux_out;
    always @(*) begin
        case(mux_ctrl)
            1'b0:mux_out=imm_in;
            1'b1:mux_out=reg_in;
        endcase
    end
endmodule