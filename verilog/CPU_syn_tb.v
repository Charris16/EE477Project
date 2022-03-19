module CPU_tb();
    logic CLK, Reset;


    logic [31:0] Instr_Addr, instruction, MEM_data, MEM_WR_out, MEM_addr;
    logic [2:0] MEM_type;
    logic MEM_rd_en, MEM_wr_en;
    instructmem INSTRUC_MEM(
        .address(Instr_Addr),
        .instruction(instruction),
        .clk(CLK)
        );
    CPU_TopLevel CPU_TopLevel0(
        .Instr_Addr(Instr_Addr),
        .MEM_addr(MEM_addr),
        .MEM_WR_out(MEM_WR_out),
        .MEM_type(MEM_type),
        .MEM_rd_en(MEM_rd_en),
        .MEM_wr_en(MEM_wr_en),
        .INSTRUCTION(instruction),
        .MEM_data(MEM_data),
        .CLK(CLK),
        .Reset(Reset)
        );
     Memory DATA_MEM(
        .address(MEM_addr),
        .write_enable(MEM_wr_en),
        .read_enable(MEM_rd_en),
        .write_data(MEM_WR_out),
        .clk(CLK),
        .xfer_size(MEM_type),
        .read_data(MEM_data)
	    );
    parameter clock_period = 10;
    initial begin
        CLK <=1'b0;
        forever #clock_period CLK <= ~CLK;
    end

    initial begin
	$sdf_annotate("../../syn/results/CPU_TopLevel.syn.sdf", CPU_TopLevel0);
        $vcdpluson;
        $dumpvars();
	    Reset <= 1'b1; @(posedge CLK);
        Reset <= 1'b0; @(posedge CLK);
        for (int i = 0; i < 330; i++) @(posedge CLK);

        $finish;
    end
endmodule
