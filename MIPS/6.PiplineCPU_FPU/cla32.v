#include "cla_32.v"
module cla32(a,b,ci,s,co);
	input [31:0]a,b;
	input ci;
	output [31:0] s;
	output co;
	wire g_out,p_out;
	
	cla_32 cla (a,b,ci,g_out,p_out,s);
	assign co=g_out|p_out&ci;
	
endmodule