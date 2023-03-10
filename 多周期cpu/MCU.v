module CU(
    input clk,
    input [31:0] MCU_in,
    input ALU_Z,
    output reg PCOeH,
    output reg PCOeL,
    output reg PCWr,
    output reg IRWr,
    output reg ImmOeH,
    output reg ImmOeL,
    output reg [1:0] ExtSel,
    output reg [1:0] ALUOp,
    //output reg [2:0] ALUCtrl,
    output reg AWr,
    output reg BWr,
    output reg ALUOe,
    output reg RegOe,
    output reg RegWr,
    output reg [1:0] RegSel,
    output reg MARWr,
    output reg MemRd,
    output reg MemWr,
    output reg MDRSrc,
    output reg MDROe,
    output reg MDRWr,
    output reg MemOe);
    
    integer period=0; //clock period
    integer ex=0;
    reg [31:0] OP_code;

always@(posedge clk)begin
    case(period)
        0:begin
            PCOeH=1;
            PCOeL=1;
            MARWr=1;
            AWr=1;
            period=period+1;
        end
        1:begin
            MemRd=1;
            MemOe=1;
            IRWr=1;
            period=period+1;
            #2
            OP_code=MCU_in;
        end
        2:begin
            ExtSel=2'b10;
            ImmOeH=1;
            ImmOeL=1;
            BWr=1;
            period=period+1;
        end
        3:begin
            ALUOp=2'b00;
            ALUOe=1;
            PCWr=1;
            period=period+1;
        end
        4:begin
            RegSel=00;
            RegOe=1;
            AWr=1;
            period=period+1;
        end
        5:begin
            case(OP_code[31:26])
                6'b100011:begin //lw
                    ExtSel=2'b00;
                    ImmOeH=1;
                    ImmOeL=1;
                    BWr=1;
                    period=period+1;
                end
                6'b101011:begin //sw
                    ExtSel=2'b00;
                    ImmOeH=1;
                    ImmOeL=1;
                    BWr=1;
                    period=period+1;
                end
                6'b000000:begin //R
                    RegSel=2'b01;
                    RegOe=1;
                    BWr=1;
                    period=period+1;
                end
                6'b000100:begin //beq
                    RegSel=2'b01;
                    RegOe=1;
                    BWr=1;
                    period=period+1;
                end
                6'b000010:begin //j
                    PCOeH=1;
                    ExtSel=2'b11;
                    ImmOeL=1;
                    PCWr=1;
                    OP_code=0;
                    period=0;
                end
            endcase
        end
        6:begin
            case(OP_code[31:26])
                6'b100011:begin //lw
                    ALUOp=2'b00;
                    //ALUCtrl=3'b100;
                    ALUOe=1;
                    MARWr=1;
                    period=period+1;
                end
                6'b101011:begin //sw
                    ALUOp=2'b00;
                    //ALUCtrl=3'b100;
                    ALUOe=1;
                    MARWr=1;
                    period=period+1;
                end
                6'b000000:begin //R
                    ALUOp=2'b10;
                    ALUOe=1;
                    RegSel=2'b10;
                    RegWr=1;
                    OP_code=0;
                    period=0;
                end
                6'b000100:begin //beq
                    ALUOp=2'b01;
                    #2
                    if(ALU_Z==0)begin
                        OP_code=0;
                        period=0;
                    end
                    else begin
                        PCOeH=1;
                        PCOeL=1;
                        AWr=1;
                        period=period+1;
                    end
                end
            endcase
        end
        7:begin
            case(OP_code[31:26])
                6'b100011:begin //lw
                    MemRd=1;
                    MDRSrc=1;
                    MDRWr=1;
                    period=period+1;
                end
                6'b101011:begin //sw
                    RegSel=2'b01;
                    RegOe=1;
                    MDRSrc=0;
                    MDRWr=1;
                    period=period+1;
                end
                6'b000100:begin //beq
                    ExtSel=2'b01;
                    ImmOeH=1;
                    ImmOeL=1;
                    BWr=1;
                    period=period+1;
                end
            endcase
        end
        8:begin
            case(OP_code[31:26])
                6'b100011:begin //lw
                    MDROe=1;
                    RegSel=2'b01;
                    RegWr=1;
                    OP_code=0;
                    period=0;
                end
                6'b101011:begin //sw
                    MemWr=1;
                    OP_code=0;
                    period=0;
                end
                6'b000100:begin //beq
                    ALUOp=2'b00;
                    //ALUCtrl=3'b100;
                    ALUOe=1;
                    PCWr=1;
                    OP_code=0;
                    period=0;
                end
            endcase
        end
    endcase
end

always@(negedge clk)begin
    PCOeH=0;
    PCOeL=0;
    PCWr=0;
    IRWr=0;
    ImmOeH=0;
    ImmOeL=0;
    ExtSel=0;
    ALUOp=0;
    //ALUCtrl=0;
    AWr=0;
    BWr=0;
    ALUOe=0;
    RegOe=0;
    RegWr=0;
    RegSel=0;
    MARWr=0;
    MemRd=0;
    MemWr=0;
    MDRSrc=0;
    MDROe=0;
    MDRWr=0;
    MemOe=0;
end
endmodule