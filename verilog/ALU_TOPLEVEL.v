module ALU_32b(
    ALU_OUT,
    RS1_DATA,
    RS2_DATA,
    PC,
    U_IMM20,
    RS2,
    IMM12,
    OPCODE,
    FUNCT3,
    FUNCT1
    );

    input logic [31:0] RS1_DATA, RS2_DATA, PC;
    input logic [19:0] U_IMM20;
    input logic [11:0] IMM12;
    input logic [6:0] OPCODE;
    input logic [4:0] RS2;
    input logic [2:0] FUNCT3;
    input logic FUNCT1;
    
    output logic [31:0] ALU_OUT;
    // output reg [3:0] FLAG_REG;

    logic [31:0] DATA0, DATA1;
    logic ALU_EN;

    ALU_Control CONTROL_UNIT(
        .DATA0(DATA0),
        .DATA1(DATA1),
        .ALU_EN(ALU_EN),
        .RS1_DATA(RS1_DATA),
        .RS2_DATA(RS2_DATA),
        .PC(PC),
        .U_IMM20(U_IMM20),
        .RS2(RS2),
        .IMM12(IMM12),
        .OPCODE(OPCODE),
        .FUNCT3(FUNCT3)
        );
    ALU_DataPath DATAPATH(
        .OUT(ALU_OUT),
        .IN0(DATA0),
        .IN1(DATA1),
        .FUNC3(FUNCT3),
        .SUB(FUNCT1),
        .ALU_EN(ALU_EN)
        );


endmodule
