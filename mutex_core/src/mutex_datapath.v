module mutex_datapath(
	input wire clk,
	input wire [31:0] instructions,
	output wire [31:0] out_wire
);

	wire is_atomic_tas;
	wire is_mem_write;
	wire [31:0] ram_read_data;     
	wire [31:0] rs1_data;
	wire [31:0] rs2_data;     
	wire [31:0] ram_address;
	wire [31:0] rd_data;
	wire ram_write_enable;
   wire [4:0] rs1_addr;
	wire [4:0] rs2_addr;	
	wire [4:0] rd_addr;
	wire [31:0] wd_data;   
	wire [31:0] data_to_memory;
	
	// --- INSTRUCTION DECODING ---
   // Instruction kablosundan adresleri kesip çıkarıyoruz
   assign rs1_addr = instructions[19:15];
   assign rs2_addr = instructions[24:20]; //Standart bir R-Type veya S-Type Instruction yapısında bitlerin dağılımı
   assign rd_addr  = instructions[11:7];
	
	assign ram_write_enable = (is_atomic_tas || is_mem_write);
	assign data_to_memory = (is_atomic_tas) ? 32'h00000001 : rs2_data;
	assign ram_address = rs1_data;
	assign out_wire = data_to_memory;
	
	mutex_control_unit mtx_cu(
		.instructions(instructions),
		.is_atomic_tas(is_atomic_tas),
		.is_mem_write(is_mem_write)
	);
	
	mutex_register_file mtx_rf(
		.clk(clk),
		.wr_en(1'b1),
		.rs1_addr(rs1_addr),
		.rs2_addr(rs2_addr),
		.rd_addr(rd_addr),
		.wd_data(ram_read_data),
		.rs1_data(rs1_data),
		.rs2_data(rs2_data)
	);
	
	mutex_data_memory mtx_dm(
		.clk(clk),
		.ram_address(ram_address),
		.ram_write_data(data_to_memory),
		.ram_write_enable(ram_write_enable),
		.ram_read_data(ram_read_data)
	);
	
endmodule
