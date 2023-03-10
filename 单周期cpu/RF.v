module RF(
    input clk,
    input [31:0] write_data,
    input [4:0] reg1,
    input [4:0] reg2,
    input [4:0] write_reg,
    input if_w,
    output reg [31:0] data1,
    output reg [31:0] data2);

    reg [31:0] memory [0:31];
    integer j;

    initial begin
        for(j=0; j<=31; j=j+1) begin
            memory[j]=j;
        end
    end

    always@(posedge clk)begin
        data1=memory[reg1];
        data2=memory[reg2];
        #1
        if(if_w)begin
            memory[write_reg]=write_data;
        end
    end
endmodule