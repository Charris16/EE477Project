`include "opcode.vh"

module control_unit (
    input logic [6:0] OPCODE,
    input logic [2:0] f3,
    input logic f1,
    input useBr, // comes from the branch control module
    
    output logic rs1_en, // selects rs1 input for alu
    output logic rs2_en, // selects rs2 input for alu
    output logic brOrJmp, // selects whether to take b or j type immediate for adding to pc
    output logic brUsed, // indicated branch or jump happened
    // output logic brOrJal, // selects whether to use b or jal for adding to pc 
    output logic br_useJalr,
    output logic [2:0] func3, // forwards alu func 3
    output logic func1, // forwards alu func 1
    output logic regWrite, // whether to write to reg file
    output logic [2:0] funcMem// function code for mem reader
);


    always_comb begin
        case (OPCODE)
        `OPC_LUI: begin
            rs1_en = 1'b0; //
            rs2_en = 1'b0; //
            brOrJmp = 1'b0; //
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = 3'b000; //
            func1 = 1'b0; //
            regWrite = 1'b1;
			funcMem = 3'b000;
        end
        `OPC_AUIPC: begin
            rs1_en = 1'b0;
            rs2_en = 1'b0;
            brOrJmp = 1'b0; //
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_JAL: begin
            rs1_en = 1'b0; //
            rs2_en = 1'b0; //
            brOrJmp = 1'b1;
            brUsed = 1'b0;
            br_useJalr = 1'b0;
            func3 = 3'b000; //
            func1 = 1'b0; //
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_JALR: begin
            rs1_en = 1'b1;
            rs2_en = 1'b0;
            brOrJmp = 1'b0; //
            brUsed = 1'b1;
            br_useJalr = 1'b1;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_BRANCH: begin
            rs1_en = 1'b1; //
            rs2_en = 1'b1; //
            brOrJmp = 1'b0;
            brUsed = 1'b0;
            br_useJalr = (useBr) ? 1'b1 : 1'b0;
            func3 = f3; //
            func1 = 1'b0; //
            regWrite = 1'b0;
            funcMem = 3'b000;
        end
        `OPC_STORE: begin
            rs1_en = 1'b1;
            rs2_en = 1'b1;
            brOrJmp = 1'b0;
            brUsed = 1'b0;
            br_useJalr = 1'b0;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b0;
            funcMem = f3;
        end
        `OPC_LOAD: begin
            rs1_en = 1'b1;
            rs2_en = 1'b0;
            brOrJmp = 1'b0; //
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b1;
            funcMem = f3;
        end
        `OPC_ARI_RTYPE: begin
            rs1_en = 1'b1;
            rs2_en = 1'b1;
            brOrJmp = 1'b0; //
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = f3;
            func1 = f1;
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_ARI_ITYPE: begin
            rs1_en = 1'b1;
            rs2_en = 1'b1;
            brOrJmp = 1'b0; //
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = f3;
            func1 = (f3 == `FNC_SRL_SRA) ? f1 : 1'b0; // always 0 except for right shifts
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        default: begin
            rs1_en = 1'b0;
            rs2_en = 1'b0;
            brOrJmp = 1'b0;
            brUsed = 1'b0;
            br_useJalr = 1'b0;
            func3 = 3'b000;
            func1 = 1'b0;
            regWrite = 1'b0;
            funcMem = 3'b000;
        end        
        endcase
    end

endmodule