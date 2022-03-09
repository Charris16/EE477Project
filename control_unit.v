`include "opcode.vh"

module control_unit (
    input [31:0] instruction,
    input useBr, // comes from the branch control module
    
    output logic [1:0] rs1Sel, // selects rs1 input for alu
    output logic [1:0] rs2Sel, // selects rs2 input for alu
    output logic brOrJmp, // selects whether to take b or j type immediate for adding to pc
    output logic [1:0] wbSel, // selects which data source to write back to regfile from
    output logic brUsed, // indicated branch or jump happened
    // output logic brOrJal, // selects whether to use b or jal for adding to pc 
    output logic br_useJalr,
    output logic [2:0] func3, // forwards alu func 3
    output logic func1, // forwards alu func 1
    output logic regWrite, // whether to write to reg file
    output logic [2:0] funcMem// function code for mem reader
);


    always_comb begin
        case (instruction[6:0])
        `OPC_LUI: begin
            rs1Sel = 2'b00; //
            rs2Sel = 2'b00; //
            brOrJmp = 1'b0; //
            wbSel = 2'b11;
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = 3'b000; //
            func1 = 1'b0; //
            regWrite = 1'b1;
			funcMem = 3'b000;
        end
        `OPC_AUIPC: begin
            rs1Sel = 2'b00;
            rs2Sel = 2'b00;
            brOrJmp = 1'b0; //
            wbSel = 2'b01;
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_JAL: begin
            rs1Sel = 2'b00; //
            rs2Sel = 2'b00; //
            brOrJmp = 1'b1;
            wbSel = 2'b00;
            brUsed = 1'b0;
            br_useJalr = 1'b0;
            func3 = 3'b000; //
            func1 = 1'b0; //
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_JALR: begin
            rs1Sel = 2'b01;
            rs2Sel = 2'b10;
            brOrJmp = 1'b0; //
            wbSel = 2'b00;
            brUsed = 1'b1;
            br_useJalr = 1'b1;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_BRANCH: begin
            rs1Sel = 2'b00; //
            rs2Sel = 2'b00; //
            brOrJmp = 1'b0;
            wbSel = 2'b00; //
            brUsed = 1'b0;
            br_useJalr = (useBr) ? 1'b1 : 1'b0;
            func3 = instruction[14:12]; //
            func1 = 1'b0; //
            regWrite = 1'b0;
            funcMem = 3'b000;
        end
        `OPC_STORE: begin
            rs1Sel = 2'b01;
            rs2Sel = 2'b01;
            brOrJmp = 1'b0;
            wbSel = 2'b00;
            brUsed = 1'b0;
            br_useJalr = 1'b0;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b0;
            funcMem = instruction[14:12];
        end
        `OPC_LOAD: begin
            rs1Sel = 2'b01;
            rs2Sel = 2'b10;
            brOrJmp = 1'b0; //
            wbSel = 2'b10;
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = `FNC_ADD_SUB;
            func1 = `FNC2_ADD;
            regWrite = 1'b1;
            funcMem = instruction[14:12];
        end
        `OPC_ARI_RTYPE: begin
            rs1Sel = 2'b01;
            rs2Sel = 2'b11;
            brOrJmp = 1'b0; //
            wbSel = 2'b01;
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = instruction[14:12];
            func1 = instruction[30];
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        `OPC_ARI_ITYPE: begin
            rs1Sel = 2'b01;
            rs2Sel = 2'b10;
            brOrJmp = 1'b0; //
            wbSel = 2'b01;
            brUsed = 1'b0; //
            br_useJalr = 1'b0;
            func3 = instruction[14:12];
            func1 = (instruction[14:12] == `FNC_SRL_SRA) ? instruction[30] : 1'b0; // always 0 except for right shifts
            regWrite = 1'b1;
            funcMem = 3'b000;
        end
        default: begin
            rs1Sel = 2'b00;
            rs2Sel = 2'b00;
            brOrJmp = 1'b0;
            wbSel = 2'b00;
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