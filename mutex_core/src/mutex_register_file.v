module mutex_register_file(
	input wire clk,
	input wire wr_en,
   input wire [4:0] rs1_addr,
	input wire [4:0] rs2_addr,	
	input wire [4:0] rd_addr,
	input wire [31:0] wd_data,   
   output wire [31:0] rs1_data,     
   output wire [31:0] rs2_data    
);

	reg [31:0] registers[0:31];
	
	// OKUMA İŞLEMİ (Combinational - x0 kuralı uygulanıyor)
   assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
   assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];
	 
	always @(posedge clk) begin
		if(wr_en && (rd_addr != 5'b0)) begin
			registers[rd_addr] <= wd_data; 
		end
	end

endmodule
