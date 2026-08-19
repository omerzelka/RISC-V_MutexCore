module mutex_control_unit(
	input wire [31:0] instructions,
	output wire is_atomic_tas,
	output wire is_mem_write
);

	localparam [6:0] MUTEXLOCK = 7'b0011111; //özel mutex kodum 
	localparam [6:0] OPCODE_STORE = 7'b0100011; //standart store kodu
	
	wire [6:0] inst_opcode = instructions[6:0];
	
	assign is_atomic_tas = (MUTEXLOCK==inst_opcode);
	assign is_mem_write = (inst_opcode == OPCODE_STORE);
endmodule
