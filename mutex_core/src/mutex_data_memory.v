module mutex_data_memory(
	input wire clk,
	input wire [31:0] ram_address,
   input wire [31:0] ram_write_data,
   input wire ram_write_enable,
	output wire [31:0] ram_read_data
);

	reg [31:0] memory_array [0:15];
	wire [9:0] word_addr = ram_address[11:2];
	
	assign ram_read_data = memory_array[word_addr];
	
	always @(posedge clk) begin
		if(ram_write_enable) begin 
			memory_array[word_addr] <= ram_write_data;
		end
	end
endmodule
