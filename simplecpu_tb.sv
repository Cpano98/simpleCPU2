`timescale 1ns / 1ps
module simplecpu_tb;

	// Inputs
	logic clk;
	logic rst;
	logic [9:0] pc;
	
	integer i;
	logic [31:0] dmem [0:127];
	logic [15:0] randdata;
	// Instantiate the Unit Under Test (UUT)
	simplecpu uut (
		.clk(clk), 
		.rst(rst),
		.pc(pc)
		/*.dmem(dmem),
		.randdata(randdata)*/
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#11;
      		rst = 0; 
		
		// INIT 
		/*for ( i=0 ; i<32 ;i = i + 1)begin
			uut.dpt.registros.mem[i] = i;
			end*/
			
		for ( i=0 ; i<256 ;i = i + 1) begin
			randdata = $random();
			uut.datamemory.mem_array[i] = {8'h0,randdata[7:0]};  
			end
			 
 

		//uut.instmem.mem_array[0] = 16'b0011010100010001;
		//uut.instmem.mem_array[1] = 16'b0011101000101110;
		//uut.instmem.mem_array[2] = 16'b0010000101011010;
		//uut.instmem.mem_array[3] = 16'b0011001010001011;
		//uut.instmem.mem_array[4] = 16'b0010001100010010;
		//uut.instmem.mem_array[5] = 16'b0001001100000001;
		//uut.instmem.mem_array[6] = 16'b0011011000001010;
		//uut.instmem.mem_array[7] = 16'b0000010000000001;
		//uut.instmem.mem_array[8] = 16'b0010101101000110;
		//uut.instmem.mem_array[9] = 16'b0001101100000010;
		//uut.instmem.mem_array[10] = 16'b0000000000000010;
		//uut.instmem.mem_array[11] = 16'b0010011001100000;
		//uut.instmem.mem_array[12] = 16'b0001011000000100;
		//uut.instmem.mem_array[13] = 16'b0000111100000100;
		//uut.instmem.mem_array[14] = 16'b0010111111110101;

		//uut.instmem.mem_array[0] = 16'b0011000100000000 ;
		//uut.instmem.mem_array[1] = 16'b0001000100000010 ;
		//uut.instmem.mem_array[2] = 16'b0000001000000010 ;
		//uut.instmem.mem_array[3] = 16'b0000001100011001 ;
		//uut.instmem.mem_array[4] = 16'b0001001100000100 ;
		//uut.instmem.mem_array[5] = 16'b0000010000000100 ;
		//uut.instmem.mem_array[6] = 16'b0000101000001010 ;
		//uut.instmem.mem_array[7] = 16'b0001101000001010 ;
		//uut.instmem.mem_array[8] = 16'b0000101100001010 ;
		//uut.instmem.mem_array[9] = 16'b0010101010100010 ;
		//uut.instmem.mem_array[10] = 16'b0010111111101010 ;
		//uut.instmem.mem_array[11] = 16'b0100111111111011 ;
		//uut.instmem.mem_array[12] = 16'b0000000000010111 ;
		//uut.instmem.mem_array[13] = 16'b0001000000000000 ;
		//uut.instmem.mem_array[14] = 16'b0000110000000000 ;

		uut.instmem.mem_array[0] = 16'b0011000100000010;
		uut.instmem.mem_array[1] = 16'b0011001000000011;
		uut.instmem.mem_array[2] = 16'b0010001100010010;
		uut.instmem.mem_array[3] = 16'b0011000001100011;
		uut.instmem.mem_array[4] = 16'b0001000000000011;
		uut.instmem.mem_array[5] = 16'b0011000100000001;
		uut.instmem.mem_array[6] = 16'b0000001000000011;
		uut.instmem.mem_array[7] = 16'b0010001100100001;
		uut.instmem.mem_array[8] = 16'b0011000000000000;
		uut.instmem.mem_array[9] = 16'b0011000100000001;
		uut.instmem.mem_array[10] = 16'b0011001000000000;
		uut.instmem.mem_array[11] = 16'b0010000000000001;
		uut.instmem.mem_array[12] = 16'b0101001011111111;
	


		
		#20000

		for ( i=0 ; i<256 ;i = i + 1)begin
			dmem[i] = uut.datamemory.mem_array[i];
		end	
	
	// DUMP del log
	
		$writememh("regbank.hex", uut.execunit.RegBank.mem);
		$writememh("memory.hex", dmem);
		
		
			
	// CHECKER
	//		for ( i=0 ; i<132 ;i = i + 1)begin
	//			error = error + (uut.dpt.registros.mem[i] != tb_regbank[i]);
	//		end	
	
	$finish();
	
	end
      
   always forever #2 clk = ~clk;		

/*
   initial begin
	
       while (1) begin   
   		// reference model
		
		logic 	[16:0] tb_regbank [16:0];	
		logic	[15:0] tb_instruction;
			
			//  monitor para leer la instrucción
			if(uut.instmem.ren)
				tb_instruction = uut.instmem.data_out;


			opcode = tb_instruction[15:12];
			result_ptr = (inst_type) == R ? tb_instruction[20:15] : tb_instruction[26:21];
			
			case ( opcode ) begin
				add: tb_result = tb_a + tb_b;
				sub: tb_result = tb_a - tb_b; 			
			endcase
	
				tb_regbank[result_ptr] = tb_result;
      end
   
   end
  */
 endmodule


