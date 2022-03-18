module regfile (
	input logic clk, rst, wr_en, 
	input logic [4:0] wr_addr, 
	input logic [31:0]wr_data, 
	input logic rd_en1, rd_en2,
	input logic [4:0] rd_addr1, rd_addr2,
	output logic [31:0] rd_data1, rd_data2
);
	//reg x0 == 0 by default
	reg[31:0] regs[0:31];
	
	//write control
	always_ff @(posedge clk) begin
		if (!rst & wr_en) begin
			//cant write to x0 reg
			if (wr_addr != 0) regs[wr_addr] <= wr_data;
			// else regs[wr_addr] <= 32'b0;
		end
	end

	//read for #1
	always_comb begin
		if (rst | !rd_en1 | rd_addr1 == 0) begin rd_data1 = 0; end
		else begin rd_data1 = regs[rd_addr1]; end
	end

	//read for #2
	always_comb begin
		if (rst | !rd_en2 | rd_addr2 == 0) begin rd_data2 = 0; end
		else begin rd_data2 = regs[rd_addr2]; end
	end
endmodule