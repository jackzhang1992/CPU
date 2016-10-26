`include "iu.v"
`include "regfile2w.v"
`include "mux2x32.v"
`include "fpu.v"
module fpu_1_iu(clock,memclock,resetn,pc,inst,ealu,malu,walu,wn,
				wd,ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,
				stall,count_div,count_sqrt,e1n,e2n,e3n,e3d,e);
				
	input clock,memclock,resetn;
	output [31:0] pc,inst,ealu,malu,walu;
	output [31:0] e3d,wd;
	output [4:0] e1n,e2n,e3n,wn;
	output ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall;
	output e;
	output [4:0] count_div,count_sqrt;
	
	wire [31:0] qfa,qfb,fa,fb,dfa,dfb,mmo,wmo;
	wire [4:0] fs,ft,fd;
	wire	 [2:0] fc;
	wire fwdla,fwdlb,fwdfa,fwdfb,wf,fasmds;
	wire e1w,e2w,e3w,wwfpr;
	iu i_u (e1n,e2n,e3n,e1w,e2w,e3w,stall,1'b0,
			dfb,e3d,clock,memclock,resetn,
			fs,ft,wmo,wrn,wwfpr,mmo,fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,fasmds,
			pc,inst,ealu,malu,walu,
			stall_lw,stall_fp,stall_lwc1,stall_swc1
	);

wire [4:0] wrn;
regfile2w fpr(fs,ft,wd,wn,ww,wmo,wrn,wwfpr,~clock,resetn,qfa,qfb);
mux2x32 fwd_f_load_a(qfa,mmo,fwdla,fa);
mux2x32 fwd_f_load_b(qfb,mmo,fwdlb,fb);
mux2x32 fwd_f_res_a(fa,e3d,fwdfa,dfa);
mux2x32 fwd_f_res_b (fb,e3d,fwdfb,dfb);

wire [1:0] e1c,e2c,e3c;
fpu fp_unit(dfa,dfb,fc,wf,fd,1'b1,clock,resetn,e3d,wd,wn,ww,
			stall,e1n,e1w,e2n,e2w,e3n,e3w,
			e1c,e2c,e3c,count_div,count_sqrt,e);
			
endmodule