module DM(
    input [31:0] DM_addr,
    input DM_r,
    input DM_w,
    input [31:0] data_write,
    output [31:0] data_read);

    reg [31:0] memory[0:255];
    reg [31:0] data_read;
    integer i;

    initial begin
        memory[0]=32'b00000000000000010001000000100001; //RF[2]=RF[0]+RF[1]=1
        memory[1]=32'b00000000100000110010100001100010; //RF[5]=RF[4]-RF[3]=1
        memory[2]=32'b10001100001001000000000000011000; //DM[24+1](9)->RF[4]=9
        memory[3]=32'b10101100010111110000000000001111; //RF[31](31)->DM[15+1]=31 
        memory[4]=32'b00000000000000010011100000101011; //RF[0]<RF[1]?->RF[7]=1(triggered)
        memory[5]=32'b00010000001000100000000000000001; //RF[1]==RF[2]?->PC+=1(triggered)
        memory[6]=32'b10001100100000000000000000000111; //DM[7+9](31)->RF[0]=31(skipped)
        memory[7]=32'b10001100100000000000000000001000; //DM[8+9](1)->RF[0]=1
        memory[8]=32'b00001000000000000000000000000000; //PC=0
                                                        //PC=0 RF[2]=RF[0]+RF[1]=2
                                                        //PC=1 RF[5]=RF[4]-RF[3]=6
                                                        //PC=2 DM[24+1](9)->RF[4]=9
                                                        //PC=3 RF[31](31)->DM[15+2]=31
                                                        //PC=4 RF[0]<RF[1]?->RF[7]=1(not triggered)
                                                        //PC=5 RF[1]==RF[2]?->PC+=1(not triggered)
                                                        //PC=6 DM[7+9](31)->RF[0]=31
                                                        //PC=7 DM[8+9](31)->RF[0]=31

        for(i=16;i<=31;i=i+1) begin
            memory[i]=i-16;
        end
    end

    always@(posedge DM_r) begin
        data_read=memory[DM_addr[7:0]];
    end

    always@(posedge DM_w) begin
        memory[DM_addr[7:0]]=data_write;
    end
endmodule

module DM_out_ctrl(input MemOe,input [31:0] in,output [31:0] out);
    reg [31:0] out;
    reg [31:0] save;

    always@(*) begin
        save=in;
    end

    always@(posedge MemOe) begin
        #1
        out=save; 
    end

    always@(negedge MemOe) out=32'bz;
endmodule

module MAR(input clk,input [31:0] MAR_IN,input MARWr,output [31:0] MAR_OUT);
    reg [31:0] MAR_OUT;
    reg [31:0] save;

    always@(*) begin
        save=MAR_IN;
    end

    always@(posedge clk) begin
        #2
        if(MARWr) MAR_OUT=MAR_IN;
    end
endmodule

module MDR(input clk,input [31:0] MDR_IN,input MDRWr,output [31:0] MDR_OUT);
    reg [31:0] MDR_OUT;
    reg [31:0] save;

    always@(*) begin
        save=MDR_IN;
    end

    always@(posedge clk) begin
        #4
        if(MDRWr) begin
            MDR_OUT=MDR_IN;
        end
    end
endmodule

module MDR_out_ctrl(input MDROe,input [31:0] in,output [31:0] out);
    reg [31:0] out;
    reg [31:0] save;

    always@(*) save=in;
    always@(posedge MDROe) out=save;
    always@(negedge MDROe) out=32'bz;
endmodule