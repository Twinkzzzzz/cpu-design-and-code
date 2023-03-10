module ALU(input [3:0] func_code,input [31:0] alu_A,input [31:0] alu_B,output [31:0] alu_C);
    reg [31:0] alu_C; 
    reg [31:0] tmp;
    integer i;
    always@(*)begin
        case(func_code)
            4'b0000:alu_C=alu_A+alu_B;
            4'b1110:alu_C=alu_A+alu_B;
            4'b0001:alu_C=alu_A-alu_B;
            4'b0010:alu_C=alu_A[15:0]*alu_B[15:0];
            4'b0011:alu_C[15:0]=alu_A[31:0]/alu_B[15:0];
            4'b0100:alu_C=alu_A&alu_B;
            4'b0101:alu_C=alu_A|alu_B;
            4'b0110:alu_C=alu_A^alu_B;
            4'b0111:begin
                if(alu_A==alu_B) alu_C=16'b0000000000000001; else alu_C=16'b0000000000000000;
            end
            4'b1000:begin
                tmp=alu_A;
                for(i=0;i<alu_B;i=i+1) tmp=tmp*(2'b10);
                alu_C=tmp;
            end
            4'b1001:begin
                tmp=alu_A;
                for(i=0;i<alu_B;i=i+1) tmp=tmp/(2'b10);
                alu_C=tmp;
            end
        endcase
    end
endmodule

module alu_PC(input [15:0] recent_pc,input [15:0] leap,output [15:0] sum);
    reg [15:0] sum;
    always @(*) begin
        sum=recent_pc+leap;
    end
endmodule