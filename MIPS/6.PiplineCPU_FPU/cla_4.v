#include "cla_2.v"
#include "g_p.v"

module cla_4(a,b,c_in,g_out,p_out,s);
	input [3:0]a,b;
	input c_in;
	output g_out,p_out;
	output [3:0]s;
	wire [1:0]g,p;
	wire c_out;
	cla_2 cla0(a[1:0],b[1:0],c_in,g[0],p[0],s[1:0]);
	cla_2 cla1(a[3:2],b[3:2],c_out,g[1],p[1],s[3:2]);
	g_p g_p0(g,p,c_in,g_out,p_out,c_out);
	
endmodule