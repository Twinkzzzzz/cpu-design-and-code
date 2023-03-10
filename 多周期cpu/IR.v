module IR(input clk,input IRWr,input [31:0] IR_in,output reg [31:0] IRout);//,output reg [4:0] IRreg1,output reg [4:0] IRreg2,output reg [4:0] IRreg3,output reg [5:0] IR_ALUfunc);
    always@(posedge clk) begin
        #2 
        if(IRWr)begin
            IRout=IR_in;
            //IRreg1=IR_in[25:21];
            //IRreg2=IR_in[20:16];
            //IRreg3=IR_in[15:11];
            //IR_ALUfunc=IR_in[5:0];
        end
    end
endmodule