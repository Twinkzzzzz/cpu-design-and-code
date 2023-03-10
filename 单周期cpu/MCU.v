module MCU
(input [1:0] opt_code,
 input [3:0] func_code,
 input clk,
 output PC_input, 
 output imm_or_dm1,
 output [1:0] assign_PC,
 output four_or_not,
 output reg2_or_imm,
 output [1:0] RF_write_data_mux,
 output cmp_for_leap,
 output RF_write,
 output DM_write,
 output DM_read,
 output DM_addr_in,
 output [1:0] reg_write_mux,
 output [3:0] ALU_ctrl);
    reg PC_input;
    reg imm_or_dm1;
    reg assign_PC;
    reg four_or_not;
    reg reg2_or_imm;
    reg [1:0] RF_write_data_mux;
    reg cmp_for_leap;
    reg RF_write;
    reg DM_write;
    reg DM_read;
    reg [1:0] reg_write_mux;
    reg [3:0] ALU_ctrl;
    reg DM_addr_in;
    always @(posedge clk) begin
        if(opt_code==2'b00) begin
            PC_input=1'b0;
            imm_or_dm1=1'b0;
            assign_PC=2'b00;
            four_or_not=1'b0;
            reg2_or_imm=1'b0;
            RF_write_data_mux=2'b00;
            cmp_for_leap=1'b0;
            RF_write=1'b1;
            DM_write=1'b0;
            DM_read=1'b0;
            reg_write_mux=2'b00;
            ALU_ctrl=func_code;
            DM_addr_in=1'b0;
        end 
        else if(opt_code==2'b01) begin
            ALU_ctrl=4'b0111;
            case(func_code)
                4'b0000:begin
                    PC_input=1'b1;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b1;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b0001:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b1;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b1;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b0010:begin
                    PC_input=1'b1;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b01;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b1;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b1;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b0011:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b1;
                    assign_PC=2'b00;
                    four_or_not=1'b1;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b1;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b1;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b0111:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b1;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b1;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b10;
                    DM_addr_in=1'b0;
                end
                4'b1000:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b1;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b1;
                end
            endcase
        end else if(opt_code==2'b10) begin
            ALU_ctrl=func_code;
            case(func_code)
                4'b1010:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b11;
                    cmp_for_leap=1'b0;
                    RF_write=1'b1;
                    DM_write=1'b0;
                    DM_read=1'b1;
                    reg_write_mux=2'b11;
                    DM_addr_in=1'b0;
                end
                4'b1011:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b10;
                    cmp_for_leap=1'b0;
                    RF_write=1'b1;
                    DM_write=1'b0;
                    DM_read=1'b0; //???
                    reg_write_mux=2'b11;
                    DM_addr_in=1'b0;
                end
                4'b1100:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b1;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b1101:begin
                    PC_input=1'b1;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b10;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b1110:begin
                    PC_input=1'b1;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b11;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b1;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                default:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b1;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b1;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b11;
                    DM_addr_in=1'b0;
                end
            endcase
        end else begin
            ALU_ctrl=func_code;
            case(func_code)
                4'b0000:begin
                    PC_input=1'b1;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b0;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b0001:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b00;
                    four_or_not=1'b1;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b0;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b0010:begin
                    PC_input=1'b1;
                    imm_or_dm1=1'b0;
                    assign_PC=2'b01;
                    four_or_not=1'b1;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b1;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
                4'b0011:begin
                    PC_input=1'b0;
                    imm_or_dm1=1'b1;
                    assign_PC=2'b00;
                    four_or_not=1'b1;
                    reg2_or_imm=1'b0;
                    RF_write_data_mux=2'b00;
                    cmp_for_leap=1'b0;
                    RF_write=1'b0;
                    DM_write=1'b0;
                    DM_read=1'b1;
                    reg_write_mux=2'b00;
                    DM_addr_in=1'b0;
                end
            endcase
        end
    end
endmodule