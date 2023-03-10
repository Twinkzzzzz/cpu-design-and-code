module PC(input clk,input PCWr,input PCOeH,input PCOeL,input [31:0] pcin,output reg [31:0] testpc,output [3:0] pcouth,output [27:0] pcoutl);
    reg[31:0] pctemp;
    reg[3:0] pcouth;
    reg[27:0] pcoutl;

    initial begin
        pctemp=32'b0;
    end

    always@(posedge clk)begin
        #2 
        if(PCWr)begin
            pctemp=pcin;
        end
    end

    always@(posedge PCOeH) pcouth=pctemp[31:28];
    always@(posedge PCOeL) pcoutl=pctemp[27:0];
    always@(negedge PCOeH) pcouth=4'bz;
    always@(negedge PCOeL) pcoutl=28'bz;
endmodule