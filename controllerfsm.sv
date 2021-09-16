typedef enum logic [3:0]
{
	INIT		= 4'b0000,
	FETCH		= 4'b0001,
	DECODE		= 4'b0010,
	LOAD		= 4'b0011,
	STORE		= 4'b0100,
	ADD		= 4'b0101,
	LOAD_CONS	= 4'b0110,
	SUB		= 4'b0111,
	JMP_IF_ZERO	= 4'b1000,
	JMPZ		= 4'b1001,
	ABS		= 4'b1010,
	ERROR		= 4'bXXXX

} t_cntrl_fsm_state;




module controllerfsm (
	input  logic			clk,
	input  logic			rst,
	input  logic [15:0]		instruction,
	input  logic     		RF_Rp_zero,	
	output logic 			PC_offset,
	output logic			PC_clr,
	output logic			PC_inc,
	output logic			I_rd,
	output logic			IR_ld,
	output logic [7:0] 		D_addr,
	output logic			D_rd,
	output logic			D_wr,
	output logic			RF_s0,
	output logic			RF_s1,
	output logic [3:0]		RF_W_addr,
	output logic			RF_W_wr,
	output logic [3:0]		RF_Rp_addr,
	output logic			RF_Rp_rd,
	output logic [3:0]		RF_Rq_addr,
	output logic			RF_Rq_rd,
	output logic [7:0]		RF_W_cons,
	output logic			alu_s0,
	output logic			alu_s1
	);
	
	
	t_cntrl_fsm_state	state;   	// Enumerated Defined type variable for FSM states
	t_cntrl_fsm_state	nxtstate;	// Enumerated Defined type variable for FSM states
	
	logic [3:0] opcode;
	
	
	assign opcode = instruction[15:12];
	
	
	// FSM COMBINATORIAL LOGIC;   STATE TRANSITION LOGIC
		always_comb begin
			case (state)
				INIT	: nxtstate = FETCH;
				FETCH	: nxtstate = DECODE;
				DECODE: begin
							case (opcode)
								4'h0 : nxtstate = LOAD;
								4'h1 : nxtstate = STORE;
								4'h2 : nxtstate = ADD;
								4'h3 : nxtstate = LOAD_CONS;
								4'h4 : nxtstate = SUB;
								4'h5 : nxtstate = JMP_IF_ZERO;
								4'h6 : nxtstate = ABS;
								default : nxtstate = ERROR;
							endcase
						  end
				LOAD	: nxtstate = FETCH;
				STORE	: nxtstate = FETCH;
				ADD	: nxtstate = FETCH;
				LOAD_CONS : nxtstate = FETCH;
				SUB	: nxtstate = FETCH;
				JMP_IF_ZERO : begin
						case(RF_Rp_zero)
							1'b0: nxtstate = FETCH;
							1'b1: nxtstate = JMPZ;
							default: nxtstate = ERROR;
						endcase
					      end
				//JMP_IF_ZERO : nxtstate = JMPZ;
				JMPZ : nxtstate = FETCH;
				ABS : nxtstate = FETCH;
				default : nxtstate = INIT;
			endcase
		end
	

	// FSM STATE REGISTER, SEQUENTIAL LOGIC
	always_ff @(posedge clk)
			state <= (rst) ? INIT : nxtstate;
	
	
	// OUTPUTS COMBINATIONAL LOGIC BASED ON STATE DECODING
	
		// Program Counter Interface
	always_comb begin 
		PC_clr = (state == INIT);
		PC_inc = (state == FETCH);
	end
	
		// Instruction Register Interface
	always_comb begin 
		IR_ld  = (state == FETCH);
		I_rd 	 = (state == FETCH);
	end
	
	// Data Memory i/f
	always_comb begin
		D_addr = ((state == LOAD) || (state == STORE)) ? instruction[7:0] : 'X;  // d
		D_rd	 = (state == LOAD)  ? 1'b1 : 'X;
		D_wr   = (state == STORE); // Data Memory Write Enable either 1 or 0  -
	end
	
	// Register File Control Signal i/f
	always_comb begin
		RF_s0			= 'X;
		RF_s1			= 'X;
		RF_W_addr	= 'X;
		RF_W_wr		= 1'b0;  // Wanted the Register File Write Enable to be 0 explicitely. 
		RF_Rp_addr	= 'X;
		RF_Rp_rd		= 'X;
		RF_Rq_addr	= 'X;
		RF_Rq_rd		= 'X;
		PC_offset		= 1'b0;

		case (state)
			//OPCODE: 0000
			LOAD  :  begin
							RF_W_addr	= instruction[11:8];	 // ra
							RF_W_wr		= 1'b1;
							RF_s0		= 1'b1;
							RF_s1		= 1'b0;
						end
			//OPCODE: 0001
			STORE	:	begin
							RF_Rp_addr	= instruction[11:8];  // ra
							RF_Rp_rd		= 1'b1;
						end
			//OPCODE: 0010
			ADD	: 	begin
							RF_Rp_addr 	= instruction[7:4];	 // rb
							RF_Rp_rd	  	= 1'b1;
							RF_s0		  	= 1'b0;
							RF_s1			= 1'b0;
							RF_Rq_addr 	= instruction[3:0];	 // rc
							RF_Rq_rd   	= 1'b1;
							RF_W_addr	= instruction[11:8];	 // ra
							RF_W_wr		= 1'b1;
						end
			//OPCODE: 0011
			LOAD_CONS  :  begin
							RF_W_addr	= instruction[11:8];	 // ra
							RF_W_wr		= 1'b1;
							RF_s0		= 1'b0;
							RF_s1		= 1'b1;
							RF_W_cons	= instruction[7:0];
						end
			
			//OPCODE: 0100
			SUB	: 	begin
							RF_Rp_addr 	= instruction[7:4];	 // rb
							RF_Rp_rd	  	= 1'b1;
							RF_s0		  	= 1'b0;
							RF_s1		  	= 1'b0;
							RF_Rq_addr 	= instruction[3:0];	 // rc
							RF_Rq_rd   	= 1'b1;
							RF_W_addr	= instruction[11:8];	 // ra
							RF_W_wr		= 1'b1;
						end
			
			//OPCODE: 0101
			JMP_IF_ZERO	:	begin
							RF_Rp_addr	= instruction[11:8];  // ra
							RF_Rp_rd	= 1'b1;
						end
			JMPZ		:	begin
							PC_offset 	= 1'b1;
						end
			
			//OPCODE: 0110
			ABS: 			begin
							RF_Rp_addr 	= instruction[7:4];	 // rb
							RF_Rp_rd	  	= 1'b1;
							RF_s0       		= 1'b1;
							RF_s1		  	= 1'b1;
							RF_W_addr	= instruction[11:8];	 // ra
							RF_W_wr		= 1'b1;
						end
		endcase
	end
	
	always_comb begin
		alu_s0 = (state == ADD);
		alu_s1 = (state == SUB);
	end
	
	//always_comb RF_W_cons = (RF_s0 == 1'b0) && (RF_s1 == 1'b1) ? instruction[7:0] : RF_W_cons;
	
endmodule
