#include "add.v"
#include "g_p.v"

module cla_2(a,b,c_in,g_out,p_out,s);
	input [1:0]a,b;
	input c_in;
	output g_out,p_out;
	output [1:0]s;
	wire [1:0]g,p;
	wire c_out;
	add add0(a[0],b[0],c_in,g[0],p[0],s[0]);
	add add1(a[1],b[1],c_out,g[1],p[1],s[1]);
	
	g_p g_p0(g,p,c_in,g_out,p_out,c_out);
	
endmodule