module CPU_TopLevel(Instr_Addr, MEM_addr, MEM_WR_out, MEM_type, MEM_rd_en, MEM_wr_en,  INSTRUCTION, MEM_data, CLK, Reset);
    input logic [31:0] INSTRUCTION, MEM_data;
    input logic CLK, Reset;
    output logic [31:0] Instr_Addr, MEM_addr, MEM_WR_out;
    output logic [2:0] MEM_type;
    output logic MEM_rd_en, MEM_wr_en;
    
    //  Stage 1 Signals
    logic [31:0] up_amt, up_amt_stage2, PC_def;  //  up_amt is delayed to arive on time with stall, Might not be needed
    logic [19:0] u_imm20, j_imm20;
    logic [11:0] IMM12, i_imm12, s_imm12, b_imm12;
    logic [11:0] b_imm12_stage2;
    logic [6:0] OPCODE;
	logic [4:0] rs1, rs2, rd;
    logic [2:0] func3;
    logic sto, func1;
    
    //  Stage 2 Signals
    logic [31:0] rd_data1_stage2, rd_data2_stage2, rdata1_forward, rdata2_forward;
    logic [31:0] INSTRUCTION_stage2, AUIPC_stage2, PC_def_stage2, PC_stage2;
    logic [19:0] u_imm20_stage2, u_imm20_stage3;
    logic [11:0] IMM12_stage2;
    logic [6:0] OPCODE_stage2;
    logic [4:0] wr_addr_stage2;
    logic [4:0] rd_addr1_stage2, rd_addr2_stage2;
    logic [2:0] FUNCT3_stage2, funcMem, f3_stage2;
    logic FUNCT1_stage2, wr_en_stage2, f1_stage2;
	logic rd_en1_stage2, rd_en2_stage2;
	
    //  Stage 3 Signals
    logic [31:0] Memory_Load; //  Loaded Data From Memory
    logic [31:0] ALU_OUT, reg_wr_data, Out_Stage3;
    logic [31:0] rd_data1_stage3, rd_data2_stage3, PC_def_stage3, PC_stage3;
    logic [11:0] IMM12_stage3;
    logic [6:0] OPCODE_stage3;
    logic [4:0] rd_addr2_stage3, wr_addr_stage3;
    logic [2:0] FUNCT3_stage3, funcMem_stage3;
    logic FUNCT1_stage3, wr_en_stage3;
    logic load_stage3, sto_stage3;

    //  Garbage Signals
    logic [1:0] wbSel;


    //  Sort of Live Outside of Pipeline Stages
    //  Branch Signals 
    logic inc_pc; //  Stage 2 branch sucess signal
    logic branch_taken, br_useJalr;
    logic brOrJmp, brUsed;
    // logic brOrJal;
    
    assign OPCODE = INSTRUCTION[6:0];
    assign sto = (OPCODE == 7'b0100011);

    decoder_unit dec_unit(
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .i_imm12(i_imm12),
        .s_imm12(s_imm12), 
        .b_imm12(b_imm12), 
        .u_imm20(u_imm20), 
        .j_imm20(j_imm20),
        .instruction(INSTRUCTION)
        );

    logic [31:0] j_imm32, b_imm32;

    signExtend_20 j_EXTEND(j_imm32, j_imm20 << 1);
    signExtend_12 b_EXTEND(b_imm32, b_imm12 << 1);
    // assign up_amt = (OPCODE == 7'b1101111) ? {{12{j_imm20[19]}}, j_imm20}<<1 : {{20{b_imm12[11]}}, b_imm12}<<1;
    assign up_amt = (OPCODE == 7'b1101111) ? j_imm32 : b_imm32;
    assign IMM12 = sto ? s_imm12 : i_imm12;
    assign func3 = instruction[14:12];
    assign func1 = instruction[30];

    pc Program_Counter(
        .IP(Instr_Addr),
        .PC_def(PC_def),
        .up_amt(up_amt_stage2),
        .b_taken(inc_pc),
        .OP(OPCODE),
        .CLK(CLK),
        .RESET(Reset)
        );
    pipelineReg_32 up_amt_pipe1(up_amt_stage2, up_amt, CLK, Reset);
    pipelineReg_32 PC_def_pipe1(PC_def_stage2, PC_def, CLK, Reset);
    pipelineReg_32 AUIPC_pipe1(PC_stage2, Instr_Addr, CLK, Reset);

    pipelineReg_20 U_imma_pipe1(u_imm20_stage2, u_imm20, CLK, Reset);
    pipelineReg_12 IMM12_pipe1(IMM12_stage2, IMM12, CLK, Reset);
    pipelineReg_12 B_imm12_pipe1(b_imm12_stage2, b_imm12, CLK, Reset);
    
    pipelineReg_7 OPCODE_pipe1(OPCODE_stage2, OPCODE, CLK, Reset);
    
    pipelineReg_5 rd_addr1_pipe1(rd_addr1_stage2, rs1, CLK, Reset);
    pipelineReg_5 rd_addr2_pipe1(rd_addr2_stage2, rs2, CLK, Reset);
    pipelineReg_5 wr_addr_pipe1(wr_addr_stage2, rd, CLK, Reset);
   
    pipelineReg_3 func3_pipe1(f3_stage2, func3, CLK, Reset);
    
    pipelineReg_1 func3_pipe1(f1_stage2, func1, CLK, Reset);

    control_unit con_unit(
        .OPCODE(OPCODE_stage2),
        .f3(f3_stage2),
        .f1(f1_stage2),
        .useBr(branch_taken), // comes from the branch control module
        .rs1_en(rd_en1_stage2), // selects rs1 input for alu
        .rs2_en(rd_en2_stage2), // selects rs2 input for alu
        .brOrJmp(brOrJmp), // selects whether to take b or j type immediate for adding to pc
        .wbSel(wbSel), // selects which data source to write back to regfile from
        .brUsed(brUsed), // indicated branch or jump happened
        // .brOrJal(brOrJal), // selects whether to use b or jal for adding to pc 
        .br_useJalr(br_useJalr),
        .func3(FUNCT3_stage2), // forwards alu func 3
        .func1(FUNCT1_stage2), // forwards alu func 1
        .regWrite(wr_en_stage2), // whether to write to reg file
        .funcMem(funcMem)// function code for mem reader
        );
    branch_control branchUnit(
        .rs1(rdata1_forward),
        .rs2(rdata2_forward),
        .func(FUNCT3_stage2),
        .useBr(branch_taken)
        );

    // assign reg_wr_data = (OPCODE_stage3 == 7'b0000011) ? Memory_Load : ALU_OUT;
    assign inc_pc = (br_useJalr & branch_taken) | brOrJmp;

    regfile REG(
        .clk(CLK),
        .rst(Reset),
        .wr_en(wr_en_stage3 | load_stage3),
        .wr_addr(wr_addr_stage3),
        .wr_data(reg_wr_data),
        .rd_en1(rd_en1_stage2),
        .rd_en2(rd_en2_stage2),
        .rd_addr1(rd_addr1_stage2),
        .rd_addr2(rd_addr2_stage2),
        .rd_data1(rd_data1_stage2),
        .rd_data2(rd_data2_stage2)
        );
   
    forward_unit ALU_FORWARD(
        .RS1_FORWARD(rdata1_forward),
        .RS2_FORWARD(rdata2_forward),
        .ALUOUT_STAGE3(reg_wr_data),
        .RS1_DATA_STAGE2(rd_data1_stage2),
        .RS2_DATA_STAGE2(rd_data2_stage2),
        .OPCODE_STAGE3(OPCODE_stage3),
        .wr_addr_STAGE3(wr_addr_stage3),
        .RADDR1_STAGE2(rd_addr1_stage2),
        .RADDR2_STAGE2(rd_addr2_stage2),
        .WR_EN_STAGE3(wr_en_stage3)
        );
    
    pipelineReg_32 PC_def_pipe2(PC_def_stage3, PC_def_stage2, CLK, Reset);
    pipelineReg_32 rd_data1_pipe2(rd_data1_stage3, rdata1_forward, CLK, Reset);
    pipelineReg_32 rd_data2_pipe2(rd_data2_stage3, rdata2_forward, CLK, Reset);
    pipelineReg_32 PC_pipe2(PC_stage3, PC_stage2, CLK, Reset);
    
    pipelineReg_20 U_imma_pipe2(u_imm20_stage3, u_imm20_stage2, CLK, Reset);
    
    pipelineReg_12 IMM12_pipe2(IMM12_stage3, IMM12_stage2, CLK, Reset);
    
    pipelineReg_7 OPCODE_pipe2(OPCODE_stage3, OPCODE_stage2, CLK, Reset);
    
    pipelineReg_5 rd_addr2_pipe2(rd_addr2_stage3, rd_addr2_stage2, CLK, Reset);
    pipelineReg_5 wr_addr_pipe2(wr_addr_stage3, wr_addr_stage2, CLK, Reset);
    
    pipelineReg_3 FUNCT3_pipe2(FUNCT3_stage3, FUNCT3_stage2, CLK, Reset);
    pipelineReg_3 FUNCTMEM_pipe2(funcMem_stage3, funcMem, CLK, Reset);
    
    pipelineReg_1 FUNCT1_pipe2(FUNCT1_stage3, FUNCT1_stage2, CLK, Reset);
    pipelineReg_1 wr_en_pipe2(wr_en_stage3, wr_en_stage2, CLK, Reset);
    
    // assign ALU_OUT = ((OPCODE == 7'b1101111) | (OPCODE == 7'b1100111)) ? PC_def_stage3 : Out_Stage3; 

    ALU_32b ALU(
        // .ALU_OUT(Out_Stage3),
        .ALU_OUT(ALU_OUT),
        // .FLAG_REG(FLAG_REG),
        .RS1_DATA(rd_data1_stage3),
        .RS2_DATA(rd_data2_stage3),
        .PC(PC_stage3),
        .U_IMM20(u_imm20_stage3),
        .RS2(rd_addr2_stage3),
        .IMM12(IMM12_stage3),
        .OPCODE(OPCODE_stage3),
        .FUNCT3(FUNCT3_stage3),
        .FUNCT1(FUNCT1_stage3)
        );

    MemControler Mem_CON(
        .MEM_wr_data(MEM_WR_out),
        .Load_data(Memory_Load),
        .xfer_size(MEM_type),
        .load(load_stage3),
        .store(sto_stage3),
        .regData(rd_data2_stage3),
        .MEM_rd_data(MEM_data),
        .OPCODE(OPCODE_stage3),
        .func3(funcMem_stage3)
        );

    ALU_OUT_SEL regWriteSelector(
        .REG_WRITE_DATA(reg_wr_data),
        .ALU_OUT(ALU_OUT),
        .MEM_LOAD(Memory_Load),
        .PC_def(PC_def_stage3),
        .OPCODE(OPCODE_stage3)
        );

    assign MEM_addr = (sto_stage3 | load_stage3)? ALU_OUT : 32'b0;
    assign MEM_wr_en = sto_stage3;
    assign MEM_rd_en = load_stage3;
endmodule
