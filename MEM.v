// Data memory.  Supports reads and writes.  Data initialized to "X".  Note that this memory is little-endian:
// The value of the first double-word is Mem[0]+Mem[1]*256+Mem[2]*256*256+ ... + Mem[7]*256^7
//
// Size is the number of bytes to transfer, and memory supports any power of 2 access size up to double-word.
// However, all accesses must be aligned.  So, the address of any access of size S must be a multiple of S.

`timescale 1ns/10ps

// How many bytes are in our memory?  Must be a power of two.
`define DATA_MEM_SIZE		1024
	
module Memory (
	input logic		[31:0]	address,
	input logic					write_enable,
	input logic					read_enable,
	input logic		[31:0]	write_data,
	input logic					clk,
	input logic		[2:0]		xfer_size,
	output logic	[31:0]	read_data
	);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	// Make sure size is a power of two and reasonable.
	initial assert((`DATA_MEM_SIZE & (`DATA_MEM_SIZE-1)) == 0 && `DATA_MEM_SIZE > 8);
	
	// Make sure accesses are reasonable.
	always_ff @(posedge clk) begin
		if (address !== 'x && (write_enable || read_enable)) begin // address or size could be all X's at startup, so ignore this case.
			assert((address & (xfer_size - 1)) == 0);	// Makes sure address is aligned.
			assert((xfer_size & (xfer_size-1)) == 0);	// Make sure size is a power of 2.
			assert(address + xfer_size <= `DATA_MEM_SIZE);	// Make sure in bounds.
		end
	end
	
	// The data storage itself.
	logic [7:0] mem [`DATA_MEM_SIZE-1:0];
	
	// Compute a properly aligned address
	logic [31:0] aligned_address;
	always_comb begin
		case (xfer_size)
		1: aligned_address = address;
		2: aligned_address = {address[31:1], 1'b0};
		4: aligned_address = {address[31:2], 2'b00};
		default: aligned_address = {address[63:2], 2'b00}; // Bad addresses forced to double-word aligned.
		endcase
	end
	
	// Handle the reads.
	integer i;
	always_comb begin
		read_data = 'x;
		if (read_enable == 1)
			for(i=0; i<xfer_size; i++)
				read_data[8*i+7 -: 8] = mem[aligned_address + i]; // 8*i+7 -: 8 means "start at 8*i+7, for 8 bits total"
	end
	
	// Handle the writes.
	integer j;
	always_ff @(posedge clk) begin
		if (write_enable)
			for(j=0; j<xfer_size; j++)
				mem[aligned_address + j] <= write_data[8*j+7 -: 8]; 
	end
endmodule
