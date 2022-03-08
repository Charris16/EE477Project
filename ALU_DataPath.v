module ALU_DataPath #(parameter N = 32) (
    OUT,
    FLAGS,
    IN0,
    IN1,
    FUNC3,
    SUB,
    ALU_EN
    );
    
    input logic [N-1:0] IN0,IN1;
    input logic [2:0] FUNC3;
    input logic SUB, ALU_EN;
    
    output logic [N-1:0] OUT;
    output logic [3:0] FLAGS;

    // temp flag ordering
    // FLAGS[0] zero
    // FLAGS[1] Carry
    // FLAGS[2] NEG
    // FLAGS[3] OVER

    logic [N-1:0] ADDER_OUT, SHIFT_OUT, SLT_OUT;
    logic ADDER_EN;
    logic C_FLAG, X_FLAG, Z_FLAG, N_FLAG;

    assign FLAGS[0] = Z_FLAG;
    assign FLAGS[1] = C_FLAG;
    assign FLAGS[2] = N_FLAG;
    assign FLAGS[3] = X_FLAG;
    
    assign N_FLAG = OUT[N-1];
    ZEROCHECK #(.N(N)) Zero_Flag(Z_FLAG, OUT);
    ADDER #(.N(N)) ADD_PATH(ADDER_OUT, C_FLAG, X_FLAG, IN0, IN1, SUB);
    shifter #(.N(N), .SMAT(5)) bit_shiter(SHIFT_OUT, IN0, IN1[4:0], FUNC3, SUB);
    
    SLT_OP SLT_LOGIC(
        .OUT(SLT_OUT),
        .FUNC3(FUNC3),
        .RS1_DATA(IN0),
        .RS2_DATA(IN1)
        );
    // OP 000  ADD SUB / ADDI
    // OP 010  SLT / SLTI
    // OP 011  SLTU / SLTUI
    
    // OP 100  XOR / XORI
    // OP 110  OR / ORI
    // OP 111  AND/ ANDI

    // OP 001 SLLI SLL
    // OP 101 SRLI SRL SRA SRAI

    always_comb begin
        case(FUNC3)
            // ADDER CASES
            3'b000: OUT = ALU_EN ? ADDER_OUT : 'b0;  // ADD SUB / ADDI
            
            // SLT and SLTU
            3'b010: OUT = ALU_EN ? SLT_OUT : 'b0;  // SLT / SLTI
            3'b011: OUT = ALU_EN ? SLT_OUT : 'b0;  // SLTU / SLTUI
            
            // LOGIC CASES
            3'b100: OUT = ALU_EN ? (IN0 ^ IN1) : 'b0; // XOR / XORI
            3'b110: OUT = ALU_EN ? (IN0 | IN1) : 'b0; // OR / ORI
            3'b111: OUT = ALU_EN ? (IN0 & IN1) : 'b0; // AND / ANDI
            
            // SHIFTER CASES
            default: OUT = ALU_EN ? SHIFT_OUT : 'b0; //  SLLI / SLL / SRLI / SRL / SRA / SRAI
        endcase
    end
endmodule 

module ZEROCHECK #(parameter N = 32)(Zero, DATA);
    input logic [N-1:0] DATA;
    output logic Zero;
    always_comb begin
        case(DATA)
            'b0: Zero = 1'b1;
            default: Zero = 1'b0;
        endcase
    end
endmodule

module ADDER #(parameter N = 32) (ADDER_OUT, COUT, X_FLAG, A, B, SUB);
    input logic [N-1:0] A, B;
    input logic SUB;
    output logic [N-1:0] ADDER_OUT;
    output logic COUT, X_FLAG;

    logic [N-1:0] B_mux;
    assign B_mux = SUB ? ~B : B;

    logic CARRY_BITS[N-1:0];

    FA adder_bit0(.SUM(ADDER_OUT[0]), .COUT(CARRY_BITS[0]), .A(A[0]), .B(B_mux[0]), .CIN(SUB));

    genvar i;
    generate
        for (i = 1; i < N; i++) begin
            FA adder_bit(.SUM(ADDER_OUT[i]), .COUT(CARRY_BITS[i]), .A(A[i]), .B(B_mux[i]), .CIN(CARRY_BITS[i-1]));
        end

    endgenerate
    assign COUT = CARRY_BITS[N-1];
    assign X_FLAG = CARRY_BITS[N-1] ^ CARRY_BITS[N-2];
endmodule

module FA (SUM, COUT, A, B, CIN);
    input logic A, B, CIN;
    output logic SUM, COUT;
    assign {COUT, SUM} =  A + B + CIN;
endmodule 

module shifter #(parameter N = 32, parameter SMAT = 5 ) (OUT, DIN, SHAMT, FUNC3, FUNC1); // SRA CURRENTLY BROKEN
    input logic signed [N-1:0] DIN;
    input logic [SMAT-1:0] SHAMT;
    input logic [2:0] FUNC3;
    input logic FUNC1;
    output logic [N-1:0] OUT;
    
    always_comb begin
        case (FUNC3)
            3'b001: OUT = DIN << SHAMT;
            3'b101: OUT = FUNC1 ? DIN >>> SHAMT : DIN >> SHAMT;
            default: OUT = 32'b0;
        endcase
    end
endmodule
