module ALU_DataPath (
    OUT,
    // FLAGS,
    IN0,
    IN1,
    FUNC3,
    SUB,
    ALU_EN
    );
    
    input logic [31:0] IN0,IN1;
    input logic [2:0] FUNC3;
    input logic SUB, ALU_EN;
    
    output logic [31:0] OUT;

    logic [31:0] ADDER_OUT, SHIFT_OUT;
    logic ADDER_EN, SLT_OUT;
    logic C_FLAG, X_FLAG, Z_FLAG, N_FLAG;

    ADDER ADD_PATH(ADDER_OUT, C_FLAG, X_FLAG, IN0, IN1, SUB);
    shifter bit_shiter(SHIFT_OUT, IN0, IN1[4:0], FUNC3, SUB);
    
    SLT_OP SLT_LOGIC(
        .OUT(SLT_OUT),
        .FUNC3(FUNC3),
        .RS1_DATA(IN0),
        .RS2_DATA(IN1)
        );

    always_comb begin
        case(FUNC3)
            // ADDER CASES
            3'b000: OUT = ALU_EN ? ADDER_OUT : 32'b0;  // ADD SUB / ADDI
            
            // SLT and SLTU
            3'b010: OUT = ALU_EN ? {31'b0, SLT_OUT} : 32'b0;  // SLT / SLTI
            3'b011: OUT = ALU_EN ? {31'b0, SLT_OUT} : 32'b0;  // SLTU / SLTUI
            
            // LOGIC CASES
            3'b100: OUT = ALU_EN ? (IN0 ^ IN1) : 32'b0; // XOR / XORI
            3'b110: OUT = ALU_EN ? (IN0 | IN1) : 32'b0; // OR / ORI
            3'b111: OUT = ALU_EN ? (IN0 & IN1) : 32'b0; // AND / ANDI
            
            // SHIFTER CASES
            default: OUT = ALU_EN ? SHIFT_OUT : 32'b0; //  SLLI / SLL / SRLI / SRL / SRA / SRAI
        endcase
    end
endmodule 


module ADDER (ADDER_OUT, COUT, X_FLAG, A, B, SUB);
    input logic [31:0] A, B;
    input logic SUB;
    output logic [31:0] ADDER_OUT;
    output logic COUT, X_FLAG;

    logic [31:0] B_mux;
    assign B_mux = SUB ? ~B : B;

    logic CARRY_BITS[31:0];

    FA adder_bit0(.SUM(ADDER_OUT[0]), .COUT(CARRY_BITS[0]), .A(A[0]), .B(B_mux[0]), .CIN(SUB));

    genvar i;
    generate
        for (i = 1; i < 32; i++) begin
            FA adder_bit(.SUM(ADDER_OUT[i]), .COUT(CARRY_BITS[i]), .A(A[i]), .B(B_mux[i]), .CIN(CARRY_BITS[i-1]));
        end

    endgenerate
    assign COUT = CARRY_BITS[31];
    assign X_FLAG = CARRY_BITS[31] ^ CARRY_BITS[30];
endmodule

module FA (SUM, COUT, A, B, CIN);
    input logic A, B, CIN;
    output logic SUM, COUT;
    assign {COUT, SUM} =  A + B + CIN;
endmodule 

module shifter(OUT, DIN, SHAMT, FUNC3, FUNC1); // SRA CURRENTLY BROKEN
    input logic [31:0] DIN;
    input logic [4:0] SHAMT;
    input logic [2:0] FUNC3;
    input logic FUNC1;
    output logic [31:0] OUT;
    
    always_comb begin
        case (FUNC3)
            3'b001: OUT = DIN << SHAMT;
            3'b101: OUT = $unsigned(FUNC1 ? $signed(DIN) >>> SHAMT : DIN >> SHAMT);
            default: OUT = 32'b0;
        endcase
    end
endmodule
