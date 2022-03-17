module ALU_Control (
    DATA0,
    DATA1,
    ALU_EN,
    RS1_DATA,
    RS2_DATA,
    PC, U_IMM20,
    RS2,
    IMM12,
    OPCODE,
    FUNCT3
    );

    input logic [31:0] RS1_DATA, RS2_DATA, PC;
    input logic [19:0] U_IMM20;
    input logic [11:0] IMM12;
    input logic [6:0] OPCODE;
    input logic [4:0] RS2;
    input logic [2:0] FUNCT3;

    output logic [31:0] DATA0, DATA1;
    output logic ALU_EN;

    logic [31:0] IMM32, U_IMM32;
    logic shift_op, INTEM, LUI, APUIC;
    signExtend_12 IMM_EXTEND(IMM32, IMM12);
    assign U_IMM32 = {U_IMM20, 12'b0};
    // ARITHMATIC AND LOGIC FUNCT3
    // FUNCT3 000  ADD SUB / ADDI
    // FUNCT3 010  SLT / SLTI
    // FUNCT3 011  SLTU / SLTUI
    // FUNCT3 100  XOR / XORI
    // FUNCT3 110  OR / ORI
    // FUNCT3 111  AND / ANDI
    // SHIFT FUNCT3
    // FUNCT3 001  SLLI
    // FUNCT3 101  SLRI / SLAI
    always_comb begin
        case(OPCODE) 
            7'b0010011: begin ALU_EN = 1'b1; INTEM = 1'b1; LUI = 1'b0; APUIC = 1'b0; end // ALU on register and Imm
            7'b0110011: begin ALU_EN = 1'b1; INTEM = 1'b0; LUI = 1'b0; APUIC = 1'b0; end // ALU on 2 registers
            7'b0100011: begin ALU_EN = 1'b1; INTEM = 1'b1; LUI = 1'b0; APUIC = 1'b0; end // Load/Store on register and Imm
            7'b0000011: begin ALU_EN = 1'b1; INTEM = 1'b1; LUI = 1'b0; APUIC = 1'b0; end // Load/Store on register two registers
            7'b0110111: begin ALU_EN = 1'b1; INTEM = 1'b1; LUI = 1'b1; APUIC = 1'b0; end // LUI
            7'b0010111: begin ALU_EN = 1'b1; INTEM = 1'b1; LUI = 1'b0; APUIC = 1'b1; end // APUIC
            // 7'b1100111: begin ALU_EN = 1'b1; INTEM = 1'b1; LUI = 1'b0; APUIC = 1'b0; end // JALR
            default: begin ALU_EN = 1'b0; INTEM = 1'b0; LUI = 1'b0; APUIC = 1'b0; end
        endcase
    end

    always_comb begin
        case(FUNCT3)
            3'b001: shift_op = 1'b1;
            3'b101: shift_op = 1'b1;
            default : shift_op = 1'b0;
        endcase
    end
    logic [31:0] const_swap, IMM_val, LUI_base;
    assign IMM_val = (LUI | APUIC) ? U_IMM32 : IMM32;
    assign const_swap = (shift_op & ~INTEM)? {27'b0, RS2} : IMM_val;
    assign LUI_base = APUIC ? PC : 32'b0;
    assign DATA0 = (APUIC | LUI) ? LUI_base : RS1_DATA;
    assign DATA1 = INTEM ? const_swap : RS2_DATA;

endmodule

// module bitExtend #(parameter N = 12, parameter MAX = 32) (EXTENDED, DATA);
//     input logic [N-1:0] DATA;
//     output logic [MAX-1:0] EXTENDED;
//     assign EXTENDED = {'b0, DATA};
// endmodule

// module signExtend #(parameter N = 12, parameter MAX = 32) (EXTENDED, DATA);
//     input logic signed [N-1:0] DATA;
//     output logic signed [MAX-1:0] EXTENDED;
//     // assign EXTENDED = {{MAX-N{DATA[N-1]}}, DATA};
//     assign EXTENDED = $signed(DATA);
// endmodule

module signExtend_20 (EXTENDED, DATA);
    input logic signed [19:0] DATA;
    output logic signed [31:0] EXTENDED;
    // assign EXTENDED = {{MAX-N{DATA[N-1]}}, DATA};
    assign EXTENDED = 32'(signed'(DATA));
endmodule

module signExtend_12 (EXTENDED, DATA);
    input logic signed [11:0] DATA;
    output logic signed [31:0] EXTENDED;
    // assign EXTENDED = {{MAX-N{DATA[N-1]}}, DATA};
    assign EXTENDED = 32'(signed'(DATA));
endmodule
