module fmul_add  (z_sum,z_carry,z);
	input [38:0] z_sum;
	input [39:0] z_carry;
	output [47:8] z;
	assign z= {1'b0,z_sum} + z_carry;

endmodule