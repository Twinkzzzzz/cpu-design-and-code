module mux_DM(input [31:0] mux_in1,input clk,input [31:0] mux_in2,input mux_ctrl,output [31:0] mux_out);
    reg [31:0] mux_out;
    always@(posedge clk)begin
        #3
        case(mux_ctrl)
            1'b1:mux_out=mux_in2;
            1'b0:mux_out=mux_in1;
        endcase
    end
endmodule

module mux_reg(input [4:0] mux_in1,input [4:0] mux_in2,input [4:0] mux_in3,input [1:0] mux_ctrl,output [4:0] mux_out);
    reg [4:0] mux_out;
    always@(*)begin
        case(mux_ctrl)
            2'b00:mux_out=mux_in1;
            2'b01:mux_out=mux_in2;
            2'b10:mux_out=mux_in3;
        endcase
    end
endmodule