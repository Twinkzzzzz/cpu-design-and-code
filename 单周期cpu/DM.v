module DM(input [15:0] addr,input R,input W,input [31:0] data_write,output reg [31:0] data_read);
    reg [31:0] memory [0:255];
    integer i;
    initial begin
        for(i=0;i<=255;i=i+1) begin
            memory[i]=i;
        end
    end
    always@(*)begin
        if(R) data_read=memory[addr];
        if(W) memory[addr]=data_write;
    end
endmodule