module shift_even_bits(a,b,shamt);
	input [23:0]a;
	output [23:0]b;
	output [4:0] shamt;
	wire [23:0] a5,a4,a3,a2,a1,a0;
	assign a5 = a;
	assign shamt[4] = ~|a5[23:8];
	assign a[4] = shamt[4]?{a5[7:0],16'b0} :a5;
	assign shamt[3] = ~|a4[23:16];
	assign a[3] = shamt[3]?{a4[15:0],8'b0} :a4;
	assign shamt[2] = ~|a3[23:20];
	assign a[2] = shamt[2]?{a3[19:0],4'b0} :a3;
	assign shamt[1] = ~|a2[23:22];
	assign a[1] = shamt[1]?{a2[21:0],2'b0} :a2;
	assign shamt[0] = 0;
	assign b = a1;
	

endmodule