module abs (
	input  logic [15:0] data,
	output logic [15:0] abs_res
);

	assign abs_res = data[15] ? ~|data + 1 : data; 	

endmodule