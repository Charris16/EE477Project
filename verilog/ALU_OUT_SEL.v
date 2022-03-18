module ALU_OUT_SEL(REG_WRITE_DATA, ALU_OUT, MEM_LOAD, PC_def, OPCODE);
    input logic [31:0] ALU_OUT, MEM_LOAD, PC_def;
    input logic [6:0] OPCODE;
    output logic [31:0] REG_WRITE_DATA;
    always_comb begin
        case(OPCODE)
            7'b1101111: REG_WRITE_DATA = PC_def; // JAL
            7'b1100111: REG_WRITE_DATA = PC_def; // JALR
            7'b0000011: REG_WRITE_DATA = MEM_LOAD; // LOAD
            default: REG_WRITE_DATA = ALU_OUT; // ADD OP
	endcase
    end
endmodule
