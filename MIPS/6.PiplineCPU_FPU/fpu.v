`include "pipelined_fadder.v"
`include "pipelined_fmul.v"
`include "fdiv_newton.v"
`include "fsqrt_newton.v"
`include "mux4x32.v"

module fpu (a,b,fc,wf,fd,ein,clk,clrn,ed,wd,wn,ww,
			stall,e1n,e1w,e2n,e2w,e3n,e3w,
			e1c,e2c,e3c,count_div,count_sqrt,e);
	input [31:0] a,b;
	input [2:0] fc;
	input wf;
	input [4:0] fd;
	input  ein;
	input clk,clrn;
	output [31:0] ed,wd;
	output e1w,e2w,e3w,ww;
	output [4:0] e1n,e2n,e3n,wn;
	output stall,e;
	output [1:0] e1c,e2c,e3c;
	output [4:0] count_div,count_sqrt;
	reg [31:0] wd;
	reg sub;
	reg [31:0] efa,efb;
	wire [31:0] s_add,s_mul,s_div,s_sqrt;
	reg [1:0] e1c,e2c,e3c;
	reg e1w,e2w,e3w,ww;
	reg [4:0] e1n,e2n,e3n,wn;
	wire busy_div,stall_div,busy_sqrt,stall_sqrt;
	wire [25:0] reg_x_div,reg_x_sqrt;
	wire fdiv =  fc[2] & ~fc[1];
	wire fsqrt = fc[2]& fc[1];
	
	pipelined_fadder f_add(efa,efb,sub,2'b0,s_add,clk,clrn,e);
	pipelined_fmul f_mul (efa,efb,2'b0,s_mul,clk,clrn,e);
	fdiv_newton f_div(a,b,2'b0,fdiv,e,clk,clrn,s_div,busy_div,
					stall_div,count_div,reg_x_div);
	fsqrt_newton f_sqrt(a,2'b0,fsqrt,e,clk,clrn,s_sqrt,busy_sqrt,stall_sqrt,count_sqrt,reg_x_sqrt);
	
	assign stall = stall_div | stall_sqrt;
	assign e = ~stall & ein;
	mux4x32 fsel (s_add,s_mul,s_div,s_sqrt,e3c,ed);
	 
	 always @(negedge clrn or posedge clk)begin
		if(clrn ==0) begin
			sub<=0;	efa<=0; 	efb<=0;
			e1c<=0;	e1w<=0;	    e1n<=0;
			e2c<=0; e2w<=0;		e2n<=0;
			e3c<=0; e3w<=0; 	e3n<=0;
			wd<=0;  ww<=0;		wn<=0;
		end else if(e)begin
			sub<=fc[0];		efa<=a; 		efb<=b;
			e1c<=fc[2:1];	e1w<=wf;	    e1n<=fb;
			e2c<=e1c; 		e2w<=e1w;		e2n<=e1n;
			e3c<=e2c;	 	e3w<=e2w; 		e3n<=e2n;
			wd<=ed;  		ww<=e3w;		wn<=e3n;
		end
	 
	 
	 end
	
		
endmodule