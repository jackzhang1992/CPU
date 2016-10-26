`include "iu_cache_tlb.v"
module cpu_cache_tlb (
		clock,memclock,resetn,v_pc,pc,inst,ealu,malu,walu,wn,wd,ww,
	stall_lw,stall_fp,stall_lwc1,stall_swc1,stall,
	mem_a,mem_data,mem_st_data,mem_access,mem_write,mem_ready
);

	input clock,memclock,resetn;
	output [31:0]v_pc,pc,inst,ealu,malu,walu;
	output [31:0]wd;
	wire [31:0] e3d;
	output [4:0] wn;
	wire [4:0]e1n,e2n,e3n;
	output ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall;
	wire e;
	wire [4:0] count_div,count_sqrt;
	output [31:0]mem_a;
	output [31:0]mem_data;
	output [31:0]mem_st_data;
	output mem_access;
	output mem_write;
	output mem_ready;
	wire [31:0] qfa,qfb,fa,dfa,dfb,efb,e3d;
	wire [4:0] fs,ft,fd;
	wire [2:0]fc;
	wire fwdla,fwdlb,fwdfa,fwdfb,wf,fasmds;
	wire e1w,e2w,e3w,wwfpr;
	wire no_cache_stall;
	iu_cache_tlb i_u(e1n,e2n,e3n,e1w,e2w,e3w,stall,1'b0,
			dfb,e3d,clock,memclock,resetn,no_cache_stall,
			fs,ft,wmo,wrn,wwfpr,mmo,fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,
			fasmds,v_pc,pc,inst,ealu,malu,walu,
			stall_lw,stall_fp,stall_lwc1,stall_swc1,mem_a,
			mem_data,mem_st_data,mem_access,mem_write,mem_ready
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