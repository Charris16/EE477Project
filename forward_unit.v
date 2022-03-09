module forward_unit (
    RS1_FORWARD,
    RS2_FORWARD,
    ALUOUT_STAGE3,
    RS1_DATA_STAGE2,
    RS2_DATA_STAGE2,
    OPCODE_STAGE3,
    wr_addr_STAGE3,
    RADDR1_STAGE2,
    RADDR2_STAGE2,
    WR_EN_STAGE3
    );

    input logic [31:0] ALUOUT_STAGE3, RS1_DATA_STAGE2, RS2_DATA_STAGE2 ;
    input logic [6:0] OPCODE_STAGE3;
    input logic [4:0] wr_addr_STAGE3, RADDR1_STAGE2, RADDR2_STAGE2;
    input logic WR_EN_STAGE3;
    
    output logic [31:0] RS1_FORWARD, RS2_FORWARD;
    
    always_comb begin
        case(OPCODE_STAGE3)
            7'b0010011: begin   // 7'b0010011 ALU w I
                if((wr_addr_STAGE3 == RADDR1_STAGE2) & WR_EN_STAGE3) RS1_FORWARD = ALUOUT_STAGE3;
                else RS1_FORWARD = RS1_DATA_STAGE2;
                if((wr_addr_STAGE3 == RADDR2_STAGE2) & WR_EN_STAGE3) RS2_FORWARD = ALUOUT_STAGE3;
                else RS2_FORWARD = RS2_DATA_STAGE2;
            end
            7'b0110011: begin // 7'b0110011 ALU 2 reg
                if((wr_addr_STAGE3 == RADDR1_STAGE2) & WR_EN_STAGE3) RS1_FORWARD = ALUOUT_STAGE3;
                else RS1_FORWARD = RS1_DATA_STAGE2;
                if((wr_addr_STAGE3 == RADDR2_STAGE2) & WR_EN_STAGE3) RS2_FORWARD = ALUOUT_STAGE3;
                else RS2_FORWARD = RS2_DATA_STAGE2;
            end

            7'b0010111: begin // LUI
                if((wr_addr_STAGE3 == RADDR1_STAGE2) & WR_EN_STAGE3) RS1_FORWARD = ALUOUT_STAGE3;
                else RS1_FORWARD = RS1_DATA_STAGE2;
                if((wr_addr_STAGE3 == RADDR2_STAGE2) & WR_EN_STAGE3) RS2_FORWARD = ALUOUT_STAGE3;
                else RS2_FORWARD = RS2_DATA_STAGE2;
            end
            7'b0110111: begin // APCLUI
                if((wr_addr_STAGE3 == RADDR1_STAGE2) & WR_EN_STAGE3) RS1_FORWARD = ALUOUT_STAGE3;
                else RS1_FORWARD = RS1_DATA_STAGE2;
                if((wr_addr_STAGE3 == RADDR2_STAGE2) & WR_EN_STAGE3) RS2_FORWARD = ALUOUT_STAGE3;
                else RS2_FORWARD = RS2_DATA_STAGE2;
            end
            default: begin RS1_FORWARD = RS1_DATA_STAGE2; RS2_FORWARD = RS2_DATA_STAGE2; end
        endcase
    end

endmodule
