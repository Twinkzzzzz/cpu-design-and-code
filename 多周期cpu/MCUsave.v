module MCU(
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
    output reg [2:0] ALUctrl,
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
    
    integer j=0;
    integer ex=0;
    reg [31:0] MCU_type;

always@(posedge clk)begin
    case(j)
        0:begin
            PCOeH=1;
            PCOeL=1;
            MARWr=1;
            AWr=1;
            j=j+1;
        end
        1:begin
            MemRd=1;
            MemOe=1;
            IRWr=1;
            j=j+1;
            #2 MCU_type=MCU_in;
        end
        2:begin
            ExtSel=2'b10;
            ImmOeH=1;
            ImmOeL=1;
            BWr=1;
            j=j+1;
        end
        3:begin
            ALUOp=2'b00;
            ALUctrl=3'b100;
            ALUOe=1;
            PCWr=1;
            j=j+1;
        end
        4:begin
            RegSel=00;
            RegOe=1;
            AWr=1;
            j=j+1;
        end
        5:begin
            case(MCU_type[31:26])
                6'b100011:begin
                    case(ex)
                        0:begin
                            ExtSel=2'b00;
                            ImmOeH=1;
                            ImmOeL=1;
                            BWr=1;
                            ex=ex+1;
                        end
                        1:begin
                            ALUOp=2'b00;
                            ALUctrl=3'b100;
                            ALUOe=1;
                            MARWr=1;
                            ex=ex+1;
                        end
                        2:begin
                            MemRd=1;
                            MDRSrc=1;
                            MDRWr=1;
                            ex=ex+1;
                        end
                        3:begin
                            MDROe=1;
                            RegSel=2'b01;
                            RegWr=1;
                            ex=0;
                            MCU_type=0;
                            j=0;
                        end
                    endcase
                end
                6'b101011:begin
                    case(ex)
                        0:begin
                            ExtSel=2'b00;
                            ImmOeH=1;
                            ImmOeL=1;
                            BWr=1;
                            ex=ex+1;
                        end
                        1:begin
                            ALUOp=2'b00;
                            ALUctrl=3'b100;
                            ALUOe=1;
                            MARWr=1;
                            ex=ex+1;
                        end
                        2:begin
                            RegSel=2'b01;
                            RegOe=1;
                            MDRSrc=0;
                            MDRWr=1;
                            ex=ex+1;
                        end
                        3:begin
                            MemWr=1;
                            ex=0;
                            MCU_type=0;
                            j=0;
                        end
                    endcase
                end
                6'b000000:begin
                    case(ex)
                        0:begin
                            RegSel=2'b01;
                            RegOe=1;
                            BWr=1;
                            ex=ex+1;
                        end
                        1:begin
                            ALUOp=2'b10;
                            ALUOe=1;
                            RegSel=2'b10;
                            RegWr=1;
                            ex=0;
                            MCU_type=0;
                            j=0;
                        end
                    endcase
                end
                6'b000100:begin
                    case(ex)
                        0:begin
                            RegSel=2'b01;
                            RegOe=1;
                            BWr=1;
                            ex=ex+1;
                        end
                        1:begin
                            // ALUOp=2'b01;
                            ALUctrl=3'b110;
                            if(ALU_Z==0)begin
                                ex=0;
                                MCU_type=0;
                                j=0;
                            end
                            else begin
                                PCOeH=1;
                                PCOeL=1;
                                AWr=1;
                                ex=ex+1;
                            end
                        end
                        2:begin
                            ExtSel=2'b01;
                            ImmOeH=1;
                            ImmOeL=1;
                            BWr=1;
                            ex=ex+1;
                        end
                        3:begin
                            ALUOp=2'b00;
                            ALUctrl=3'b100;
                            ALUOe=1;
                            PCWr=1;
                            ex=0;
                            MCU_type=0;
                            j=0;
                        end
                    endcase
                end
                6'b000010:begin
                    PCOeH=1;
                    ExtSel=2'b11;
                    ImmOeL=1;
                    PCWr=1;
                    ex=0;
                    MCU_type=0;
                    j=0;
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
    ALUctrl=0;
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