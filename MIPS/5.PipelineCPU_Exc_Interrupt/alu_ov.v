module alu_ov(a,b,aluc,r,z,v);
	input [31:0] a,b;
	input [3:0] aluc;
	output [31:0] r;
	output z,v;
	wire [31:0] d_and = a & b;
	wire [31:0] d_or = a | b;
	wire [31:0] d_xor = a ^ b;
	wire [31:0] d_lui = {b[15:0],16'h0};
	wire [31:0] d_and_or = aluc[2] ? d_or :d_and;
	wire [31:0] d_xor_lui = aluc[2]? d_lui : d_xor;
	wire [31:0] d_as,d_sh;
	abbsub32 as32 (a,b,aluc[2],d_as);
	shift shifter (b,a[4:0],aluc[2],aluc[3],d_sh);
	mux4x32 select (d_as,d_and_or,d_xor_lui,d_sh,aluc[1:0],r);
	assign z = ~|r;
	assign v = ~aluc[2]&~a[31]&~b[31]& r[31]&~aluc[1]&~aluc[0]|
			   ~aluc[2]& a[31]& b[31]&~r[31]&~aluc[1]&~aluc[0]|
			    aluc[2]&~a[31]& b[31]& r[31]&~aluc[1]&~aluc[0]|
			    aluc[2]& a[31]&~b[31]&~r[31]&~aluc[1]&~aluc[0];
				
endmodule 