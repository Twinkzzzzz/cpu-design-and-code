module sigext(input [31:0] in,input [1:0] extsel,input ImmOeH,input ImmOeL,output reg [3:0] out4,output reg [27:0] out28);
    reg [31:0] out;
    always@(*)begin
        case(extsel)
            2'b10:begin
                out=32'h00000001;
            end
            2'b11:begin
                out[31:26]=6'b0;
                out[25:0]=in[25:0];
                //out=out<<2;
            end
            default begin
                out[15:0]=in[15:0];
                case(in[15])
                    1'b1:out[31:16]=16'hffff;
                    1'b0:out[31:16]=16'h0;
                endcase
                //if(extsel[0]) out=out<<2;
            end
        endcase
    end

    always@(posedge ImmOeH) begin
        out4=out[31:28];
    end

    always@(posedge ImmOeL) begin 
        out28=out[27:0];
    end

    always@(negedge ImmOeH) begin 
        out4=4'bz;
    end

    always@(negedge ImmOeL) begin 
        out28=28'bz;
    end
endmodule