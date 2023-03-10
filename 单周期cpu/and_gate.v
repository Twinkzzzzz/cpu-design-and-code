module and_gate1(input A,input B,output C);
    reg C;
    always@(*) begin
        C=A&B;
    end
endmodule

module and_gate2(input A,input B,output C);
    reg C;
    always@(*) begin
        C=A&B;
    end
endmodule