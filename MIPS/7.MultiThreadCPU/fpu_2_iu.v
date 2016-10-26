`include "iu.v"
`include "regfile2w.v"
`include "mux2x32.v"
`include "fpu.v"
module fpu_2_iu(resetn,memclock,clock,
		pc0,inst0,ealu0,malu0,walu0,ww0,
		stall_lw0,stall_lwc0,stall_swc0,stall_fp0,stall0,st0,
		pc1,inst1,ealu1,malu1,walu1,ww1,
		stall_lw1,stall_lwc1,stall_swc1,stall_fp1,stall1,st1,
		wn,wd,count_div,count_sqrt,e1n,e2n,e3n,e3d,e);
		input clock,memclock,resetn;
		output [31:0] pc0,inst0,ealu0,malu0,walu0,ww0;
		output [31:0] pc1,inst1,ealu1,malu1,walu1,ww1;
		output ww0,stall_lw0,stall_lwc0,stall_swc0,stall_fp0,stall0,st0;
		output ww1,stall_lw1,stall_lwc1,stall_swc1,stall_fp1,stall1,st1;
		output e;
		output [31:0] e3d,wd;
		output [4:0] e1n.e2n,e3n,wn;
		output [4:0] count_div,count_sqrt;
		
		//threading 0
		wire [31:0] qfa0,qfb0,fa0,fb0,dfa0,dfb0,mmo0,wmo0;
		wire [4:0] fs0,ft0,fd0,wrn0;
		wire [2:0] fc0;
		wire fwdla0,fwdlb0,fwdfa0,fwdfb0,wf0,fasmds0;
		iu iu0(e1n,e2n,e3n,e1w0,e2w0,e3w0,stall0,st0,
			dfb0,e3d,clock,memclock,resetn,
			fs0,ft0,wmo0,wrn0,wwfpr0,mmo0,fwdla0,fwdlb0,fwdfa0,fwdfb0,
			fd0,fc0,wf0,fasmds0,pc0,inst0,ealu0,malu0,walu0,
			stall_lw0,stall_fp0,stall_lwc10,stall_swc10);
		regfile2w fpr0(fs0,ft0,wd,wn,ww0,wmo0,mrn0,wwfpr0,
			~clock,resetn,qfa0,qfb0);
		
		mux2x32 fwd_f_load_a0(qfa,mmo0,fwdla0,fa0);
		mux2x32 fwd_f_load_b0(qfb,mmo0,fwdlb0,fb0);
		mux2x32 fwd_f_res_a0(fa0,e3d,fwdfa0,dfa0);
		mux2x32 fwd_f_res_b0(fb0,e3d,fwdfb0,dfb0);
		
		//threading 1
		wire [31:1] qfa1,qfb1,fa1,fb1,dfa1,dfb1,mmo1,wmo1;
		wire [4:1] fs1,ft1,fd1,wrn1;
		wire [2:1] fc1;
		wire fwdla1,fwdlb1,fwdfa1,fwdfb1,wf1,fasmds1;
		iu iu1(e1n,e2n,e3n,e1w1,e2w1,e3w1,stall1,st1,
			dfb1,e3d,clock,memclock,resetn,
			fs1,ft1,wmo1,wrn1,wwfpr1,mmo1,fwdla1,fwdlb1,fwdfa1,fwdfb1,
			fd1,fc1,wf1,fasmds1,pc1,inst1,ealu1,malu1,walu1,
			stall_lw1,stall_fp1,stall_lwc11,stall_swc11);
		regfile2w fpr1(fs1,ft1,wd,wn,ww1,wmo1,mrn1,wwfpr1,
			~clock,resetn,qfa1,qfb1);
		
		mux2x32 fwd_f_load_a1(qfa,mmo1,fwdla1,fa1);
		mux2x32 fwd_f_load_b1(qfb,mmo1,fwdlb1,fb1);
		mux2x32 fwd_f_res_a1(fa1,e3d,fwdfa1,dfa1);
		mux2x32 fwd_f_res_b1(fb1,e3d,fwdfb1,dfb1);
		//shared fpu
		wire [1:0] e1c,e2c,e3c;
		fpu fp_unit(dfa,dfb,fc,wf,fd,1'b1,clock,resetn,e3d,wd,wn,ww,
			stall,e1n,e1w,e2n,e2w,e3n,e3w,
			e1c,e2c,e3c,count_div,count_sqrt,e);
		
		//MUX
		wrie [31:0] dfa,dfb;
		wire [4:0] fd;
		wire [2:0] fc;
		wire wf;
		assign dfa = dt? dfa1:dfa0;
		assign dfb = dt? dfb1:dfb0;
		assign fd = dt ? fd1:fd0;
		assign wf = dt ?wf1:wf0;
		assign fc = dt? fc1 : fc0;
		
		
		//DEMUX
		wire stall0 = stall & ~dt; wire stall1 = stall & dt;
		wire e1w0 = e1w & ~e1t; 	wire e1w1 = e1w & e1t ;
		wire e2w0 = e2w & ~e2t; 	wire e2w2 = e2w & e2t ;
		wire e3w0 = e3w & ~e3t; 	wire e3w3 = e3w & e3t ;
		wire ww0 = ww & ~wt; 		wire ww1 = ww & wt;
		
		//thread selection
		assign st0 = cnt & fasmds0 & fasmds1;
		assign st1 = ~cnt & fasmds0 & fasmds1;
		wire dt = ~fasmds0 & fasmds1 | cnt & fasmds1;
		
		
		//count for thread selection
		reg cnt;
		always @(negedge resetn or posedge clock)begin
			if(resetn == 0)begin
				cnt<=0;
			end else if(e)begin
				cnt<=~cnt;
			end
		end
		//pipelined thread info
		reg e1t,e2t,e3t,wt;
		always @(negedge resetn or posedge clock)begin
			if(resetn ==0) begin
				e1t<=0;  e2t<=0; e3t<=0; wt<=0;
			end else if(e)begin
				e1t<=dt; e2t<=e1t; e3t<=e2t; wt<= e3t;
			end
		end
		
		
endmodule