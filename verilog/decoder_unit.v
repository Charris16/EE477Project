
module decoder_unit(
	instruction,
	rs1,
	rs2,
	rd,
	i_imm12,
	s_imm12,
	b_imm12,
	u_imm20,
	j_imm20,
	OPCODE,
	func3,
	func1
	);

	input logic [31:0] instruction;
	output logic [4:0] rs1;
	output logic [4:0] rs2;
	output logic [4:0] rd;
	output logic [11:0] i_imm12;
	output logic [11:0] s_imm12;
	output logic [11:0] b_imm12;
	output logic [19:0] u_imm20;
	output logic [19:0] j_imm20;
	output logic [6:0] OPCODE;
	output logic [2:0] func3;
	output logic func1;
	
	
	assign OPCODE = instruction[6:0];
	assign func3 = instruction[14:12];
    assign func1 = instruction[30];
	assign rs1 = instruction[19:15];
	assign rs2 = instruction[24:20];
	assign rd  = instruction[11:7];
	assign i_imm12 = instruction[31:20];
	assign s_imm12 = {instruction[31:25], instruction[11:7]};
	assign b_imm12 = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
	assign u_imm20 = instruction[31:12];
	assign j_imm20 = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};

	

endmodule
