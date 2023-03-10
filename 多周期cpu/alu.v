module ALU(input [31:0] A,input [31:0] B,input [2:0] alu_ctrl,input ALUOe,output [31:0] alu_out_real,output Z);
    reg [31:0] C; 
    reg [32:0] C_with_Z;
    reg [31:0] alu_out_real;
    reg Z;
    always@(*)begin
        Z=0;
        case(alu_ctrl)
            3'b100:begin 
                C_with_Z=A+B;
                C=C_with_Z[31:0];
                Z=C_with_Z[32];
            end
            3'b110:begin
                C_with_Z=A-B;
                C=C_with_Z[31:0];
                Z=(A<B);
            end
            3'b101:C=A+B;
            3'b000:C=A&B;
            3'b001:C=A|B;
            3'b011:C=A^B;
            3'b010:begin
                if(A<B) begin
                    C=33'b00000000000000000000000000000001;
                end
                else begin
                    C=33'b00000000000000000000000000000000;
                end
            end
            3'b111:begin
                if(A==B) begin
                    Z=1'b1;
                end
                else begin
                    Z=1'b0;
                end
            end
        endcase
    end

    always@(posedge ALUOe) begin
        #1
        alu_out_real=C;
    end

    always@(negedge ALUOe) begin
        alu_out_real=32'bz;
    end
endmodule

module ALUCU(input [1:0] alu_op,input [5:0] func_code,output [2:0] alu_ctrl);
    reg [2:0] alu_ctrl;
    always@(*)begin
        case(alu_op)
            2'b00:alu_ctrl=3'b100; //PC+4
            2'b01:alu_ctrl=3'b111; //beq
        endcase
        if(alu_op[1]==1'b1)begin //常规算数指令
            case(func_code)
                6'b100000:alu_ctrl=3'b100; //+(jud)
                6'b100001:alu_ctrl=3'b101; //+
                6'b100010:alu_ctrl=3'b110; //-
                6'b100100:alu_ctrl=3'b000; //&
                6'b100101:alu_ctrl=3'b001; //|
                6'b101010:alu_ctrl=3'b011; //^
                6'b101011:alu_ctrl=3'b010; //A<B->1 else 0
            endcase
        end
    end
endmodule

module ALUsaveA(input AWr,input [31:0] in,output [31:0] out);
    reg [31:0] out; 
    reg [31:0] save;
    always@(posedge AWr) begin
        #2
        out=in;
    end
endmodule

module ALUsaveB(input BWr,input [31:0] in,output [31:0] out);
    reg [31:0] out; 
    reg [31:0] save;
    always@(posedge BWr)begin
        #2
        out=in;
    end
endmodule