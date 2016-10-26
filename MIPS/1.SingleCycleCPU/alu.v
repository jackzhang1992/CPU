#include "addsub32.v"
#include "mux4x32.v"
//#include "shift.v"

module alu(a,b,aluc,r,z);
	input [31:0]a,b;
	input [3:0]aluc;
	output[31:0]r;
	output z;
	
	//aluc [3:0]
	//x 0 0 0 ADD
	//x 1 0 0 SUB
	//x 0 0 1 AND
	//x 1 0 1 OR
	//x 0 1 0 XOR
	//x 1 1 0 LUI
	//0 0 1 1 SLL
	//0 1 1 1 SRL
	//1 1 1 1 SRA//
	
	
	
	wire [31:0]d_and=a&b;                          
	wire [31:0]d_or=a|b;
	wire [31:0]d_xor=a^b;
	wire [31:0]d_lui={b[15:0],16'h0};
	wire [31:0]d_and_or=aluc[2]?d_or:d_and;
	wire [31:0]d_xor_lui=aluc[2]?d_lui:d_xor;
	wire [31:0]d_as,d_sh;
	
	addsub32 as32(a,b,aluc[2],d_as);
	shift shifter(b,a[4:0],aluc[2],aluc[3],d_sh);
	mux4x32 select(d_as,d_and_or,d_xor_lui,d_sh,aluc[1:0],r);
	assign z=~|r;
	
	
endmodule