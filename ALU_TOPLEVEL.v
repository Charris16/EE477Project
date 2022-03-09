module ALU_32b(
    ALU_OUT,
    // FLAG_REG,
    RS1_DATA,
    RS2_DATA,
    PC, U_IMM20,
    RS2, IMM12,
    OPCODE,FUNCT3,
    FUNCT1,
    CLK
    );

    input logic [31:0] RS1_DATA, RS2_DATA, PC;
    input logic [19:0] U_IMM20;
    input logic [11:0] IMM12;
    input logic [6:0] OPCODE;
    input logic [4:0] RS2;
    input logic [2:0] FUNCT3;
    input logic CLK, FUNCT1;
    
    output logic [31:0] ALU_OUT;
    // output reg [3:0] FLAG_REG;

    logic [31:0] DATA0, DATA1;
    logic ALU_EN;

    ALU_Control #(.N(32)) CONTROL_UNIT(DATA0, DATA1, ALU_EN, RS1_DATA, RS2_DATA, PC, U_IMM20, RS2, IMM12, OPCODE, FUNCT3, FUNCT1);
    ALU_DataPath #(.N(32)) DATAPATH(ALU_OUT, DATA0, DATA1, FUNCT3, FUNCT1, ALU_EN);

    // always_ff @(posedge CLK) begin
    //     if (ALU_EN) FLAG_REG <= FLAGS;
    //     else FLAG_REG <= FLAG_REG;
    // end

endmodule
