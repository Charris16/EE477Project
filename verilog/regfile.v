module regfile (
	input logic clk, rst, wr_en, 
	input logic [4:0] wr_addr, 
	input logic [31:0]wr_data, 
	input logic rd_en1, rd_en2,
	input logic [4:0] rd_addr1, rd_addr2,
	output logic [31:0] rd_data1, rd_data2
);
    reg[31:0] regs[31:0];

    always_ff @(posedge clk) begin
		if (rst) for (int i = 0; i < 32; i++) regs[i] <= 0;
		else begin
			if (wr_en) begin
				if (wr_addr != 5'b0) regs[wr_addr] <= wr_data;
				else regs[0] <= 32'b0;
			end
			else regs[wr_addr] <= regs[wr_addr];
		end
    end

    always_comb begin
        if (rd_en1) rd_data1 = regs[rd_addr1];
        else rd_data1 = 32'b0;
    end

    always_comb begin
        if (rd_en2) rd_data2 = regs[rd_addr2];
        else rd_data2 = 32'b0;
    end

endmodule