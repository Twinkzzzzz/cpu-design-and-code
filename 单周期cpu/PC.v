module PC(input clk,input [15:0] in,output [15:0] out);
    reg [15:0] out;
    initial begin
        out = 16'b0;
    end
    always@(posedge clk)begin
        #2 out=in;
    end
endmodule