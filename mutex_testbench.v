`timescale 1ns/1ps
module mutex_testbench();

	reg clk;
	reg [31:0] test_instruction;
	
	mutex_datapath uut(
		.clk(clk),
		.instructions(test_instruction)
	);
	
	initial begin
		clk = 0;
      forever #5 clk = ~clk;
    end
	
	initial begin
		$display("--- SIMULATION START ---\n");
        
      // push '4' address(Word 1 in the RAM) to register x5
      uut.mtx_rf.registers[5] = 32'h00000004; 
       
      // push fake data to register x 6 to control Normal Store command
      uut.mtx_rf.registers[6] = 32'hDEADBEEF;
		  
      // Lock on
      uut.mtx_dm.memory_array[1] = 32'h00000000;

      test_instruction = 32'h00000000; // No Operation
      #10;

      $display("Lock on. Atomic TAS command is executing...");
      // Instruction yapısı: rs1=5, rd=10, opcode=MUTEXLOCK
      test_instruction = 32'h0002851F;
      #10;
      $display("-> Read Data: %h (Expected: 00000000)", uut.ram_read_data);
      $display("-> Write Data to RAM: %h (Expected: 00000001)\n", uut.data_to_memory);

      // KİLİT DOLUYKEN TAS İŞLEMİ ---
      // Bir önceki komut kilidi 1 yaptı. Simdi tekrar aynı komutu yolluyoruz.
      $display("Lock off. Atomic TAS command is executing...");
      test_instruction = 32'h0002851F;
      #10;
      $display("-> Read Data: %h (Expected: 00000001)", uut.ram_read_data);
      $display("-> Write Data to RAMs: %h (Expected: 00000001)\n", uut.data_to_memory);

      // NORMAL STORE İŞLEMİ ---
      // Standart RISC-V Store (sw) komutu ile x6'daki veriyi (DEADBEEF) RAM'e yazalım.
      // Instruction: rs2=6, rs1=5, opcode=0100011 (STORE) -> Hex karşılığı: 0062A023
      $display("Normal Store command is executing... DEADBEEF will write...");
      test_instruction = 32'h0062A023;
      #10;  
		$display("-> Write Data to RAM: %h (Expected: deadbeef)\n", uut.data_to_memory);
      
		$display("--- SIMULATION END ---");
      $finish;
	 end
	 
	 initial begin
		$dumpfile("mutex_test.vcd");
		$dumpvars(0,mutex_testbench);
	 end
endmodule
