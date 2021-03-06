module controlunit (
	input  logic			clk,
	input  logic 			rst,
	input  logic [15:0]		inst,
	input  logic 			RF_Rp_zero,
	output logic [15:0]		progcntr,
	output logic			fetch,
	output logic [7:0]		D_addr,
	output logic 			D_rd,
	output logic			D_wr,
	output logic			RF_s0,
	output logic			RF_s1,
	output logic [3:0]		RF_W_addr,
	output logic			RF_W_wr,
	output logic [3:0]		RF_Rp_addr,
	output logic			RF_Rp_rd,
	output logic [3:0]		RF_Rq_addr,
	output logic 			RF_Rq_rd,
	output logic [7:0]		RF_W_cons,
	output logic 			alu_s0,
	output logic 			alu_s1
	);
	
	
	logic 			up;
	logic				ld;
	logic				clr;
	logic [15:0]	instruction_reg;
	logic		PC_offset;
	
	// Program Counter Hardware description
	// This always statement describes a register with a combinatorial incrementer at the 'D' input
	
	always_ff @ (posedge clk)
		if (rst|clr)
			progcntr <= '0;
		else if (up)
			progcntr <= progcntr + 1'b1;
		else if (PC_offset)
			progcntr <= progcntr + ~|instruction_reg[7:0] - 2'b10;
	

	always_ff @ (posedge clk)
		if (rst)
			instruction_reg <= '0;
		else if (ld)
			instruction_reg <= inst;
	
	
	controllerfsm fsm (
								.clk			(clk),
								.rst			(rst),
								.instruction(instruction_reg),
								.RF_Rp_zero	(RF_Rp_zero),
								.PC_offset	(PC_offset),
								.PC_clr		(clr),
								.PC_inc		(up),
								.I_rd			(fetch),
								.IR_ld		(ld),
								.D_addr		(D_addr),
								.D_rd			(D_rd),
								.D_wr			(D_wr),
								.RF_s0			(RF_s0),
								.RF_s1			(RF_s1),
								.RF_W_addr	(RF_W_addr),
								.RF_W_wr		(RF_W_wr),
								.RF_Rp_addr	(RF_Rp_addr),
								.RF_Rp_rd	(RF_Rp_rd),
								.RF_Rq_addr	(RF_Rq_addr),
								.RF_Rq_rd	(RF_Rq_rd),
								.RF_W_cons	(RF_W_cons),
								.alu_s0		(alu_s0),
								.alu_s1		(alu_s1)
							);
								
	
endmodule
