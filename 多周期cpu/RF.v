module RF(
    input clk,
    input [31:0] RF_Wdata,
    input [4:0] RF_reg,
    input RF_Oe,
    input RF_w,
    output reg [31:0] RF_Rdata);

    reg [31:0] RF_memory[0:31];
    integer j;

    initial begin
        for(j=0; j<=31; j=j+1)begin
            RF_memory[j]=j;
        end
    end

    always@(posedge clk) begin
        #2
        if(RF_w) RF_memory[RF_reg]=RF_Wdata;
        if(RF_Oe) RF_Rdata=RF_memory[RF_reg];
    end

    always@(negedge RF_Oe) begin
        RF_Rdata=32'bz;
    end
endmodule