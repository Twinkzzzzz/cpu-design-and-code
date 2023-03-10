module sigext(input [15:0] data,output [31:0] out);
    reg [31:0] out;
    always @(*) begin
        case(data[15])
            1'b1:out[31:16] = 16'hffff;
            1'b0:out[31:16] = 16'h0;
        endcase
        out[15:0]=data[15:0];
    end
endmodule