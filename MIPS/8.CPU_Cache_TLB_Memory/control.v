module control(op,func,rs,rt,fs,ft,rsrtequ,
				ewfpr,ewreg,em2reg,ern,
				mwfpr,mwreg,mm2reg,mrn,
				e1w,e1n,e2w,e2n,e3w,e3n,stall,st,
				pcsource,wpcir,wreg,m2reg,wmem,jal,aluc,
				sta,aluimm,shift,sext,regrt,fwda,fwdb,
				swfp,fwdf,fwdfe,wfpr,
				fwd1a,fwd1b,fwdfa,fwdfb,fc,wf,fasmds,
				stall_lw,stall_fp,stall_lwc1,stall_swc1,
				windex,wentlo,wcontx,wenthi,rc0,wc0,tlbwi,tlbwr,
				c0rn,wepc,wcau,wsta,isbr,sepc,cancel,cause,exc,selpc,ldst,
				wisbr,ecancel,itlb_exc,dtlb_exc);
input rsrtequ,ewreg,em2reg,ewfpr,mwreg,mm2reg,mwfpr;
input e1w,e2w,e3w,stall_div_sqrt,st;
input[5:0] op,func;
input [4:0] rs,rt,fs,ft,ern,mrn,e1n,e2n,e3n;
output wpcir,wreg,m2reg,wmem,jal,aluimm,shift,sext,regrt;
output swfp,fwdf,fwdfe;
output fwd1a,fwd1b,fwdfa,fwdfb;
output wfpr,wf,fasmds;
output [1:0] pcsource,fwda,fwdb;
output [3:0]aluc;
output [2:0] fc;
output stall_lw,stall_fp,stall_lwc1,stall_swc1;
output windex,wentlo,wcontx,wenthi,rc0,wc0,tlbwi,tlbwr;
output [1:0] c0rn, sepc, selpc;
output wepc, wcau, wsta, isbr, cancel, exc, ldst;
output [31:0] cause;
input wisbr, ecancel, itlb_exc, dtlb_exc;

assign ldst = (i_lw | i_sw | i_lwc1 | i_swc1) & ~ecancel & ~ dtlb_exc;
assign isbr = i_beq | i_bne | i_j | i_jal;

assign sepc[1] = ~ ~itlb_exc & dtlb_exc;
assign sepc[0] = itlb_exc & isbr | ~itlb_exc & dtlb_exc & wisbr ;
assign exc = itlb_exc & sta[4] | dtlb_exc & sta[5];

assign cancel = exc;

assign selpc[1] = exc;
assign selpc[0] = i_eret;

wire i_mtc0 = (op == 6'h10) & (rs == 5'h04) & (func == 6'h00);
wire i_mfc0 = (op == 6'h10) & (rs == 5'h00) & (func == 6'h00);
wire i_eret = (op == 6'h10) & (rs == 5'h10) & (func == 6'h18);
assign tlbwi = (op == 6'h10) & (rs == 5'h10) & (func == 6'h02);
assign tlbwr = (op == 6'h10) & (rs == 5'h10) & (func == 6'h06);
assign windex = i_mtc0 & (rd == 5'h00);
assign wentlo = i_mtc0 &(rd == 5'h02);
assign wcontx = i_mtc0 &(rd == 5'h04);
assign wenthi = i_mtc0 &(rd == 5'h09);
assign wsta = i_mtc0 &	(rd == 5'h0c);
assign wcau = i_mtc0 &(rd == 5'h0d);
assign wepc = i_mtc0 &(rd == 5'h0e);
wire rstatus = i_mfc0 &(rd == 5'h0c);
wire rcause = i_mfc0 &(rd == 5'h0d);
wire repc = i_mfc0 & (rd == 5'h0e);
assign c0rn[1] = rcause | repc ;
assign c0rn[1] = rstatus | repc;
assign rc0 = i_mfc0;
assign wc0 = i_mtc0;
wire [2:0] exccode;
assign exccode[2] = itlb_exc | dtlb_exc;
assign exccode[1] = 1'b0;
assign exccode[0] = dtlb_exc;
assign cause = {27'h0,exccode,2'b00};



wire r_type,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;
and(r_type,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);
and (i_add,r_type, func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
and (i_sub,r_type, func[5],~func[4],~func[3],~func[2], func[1],~func[0]);
and (i_and,r_type, func[5],~func[4],~func[3], func[2],~func[1],~func[0]);
and (i_or ,r_type, func[5],~func[4],~func[3], func[2],~func[1], func[0]);
and (i_xor,r_type,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
and (i_sll,r_type, func[5],~func[4],~func[3], func[2], func[1],~func[0]);
and (i_srl,r_type,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
and (i_sra,r_type,~func[5],~func[4],~func[3],~func[2], func[1], func[0]);
and (i_jr ,r_type,~func[5],~func[4], func[3],~func[2],~func[1],~func[0]);
wire i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui;
and (i_addi,~op[5],~op[4], op[3],~op[2],~op[1],~op[0]);
and (i_andi,~op[5],~op[4], op[3], op[2],~op[1],~op[0]);
and (i_ori ,~op[5],~op[4], op[3], op[2],~op[1],op[0]);
and (i_xori,~op[5],~op[4], op[3], op[2], op[1],~op[0]);
and (i_lw, op[5],~op[4],~op[3],~op[2], op[1],op[0]);
and (i_sw, op[5],~op[4], op[3],~op[2], op[1],op[0]);
and (i_beq,~op[5],~op[4],~op[3],op[2],~op[1],~op[0]);
and (i_bne,~op[5],~op[4],~op[3],op[2],~op[1], op[0]);
and (i_lui,~op[5],~op[4], op[3], op[2], op[1],op[0]);
wire i_j,i_jal;
and (i_j,~op[5],~op[4],~op[3],~op[2], op[1],~op[0]);
and (i_jal,~op[5],~op[4],~op[3],~op[2], op[1], op[0]);
wire f_type,i_lwc1,i_swc1,i_fadd,i_fsub,i_fmul,i_fdiv,i_fsqrt;
and(f_type,~op[5], op[4],~op[3],~op[2],~op[1], op[0]);
and(i_lwc1, op[5], op[4],~op[3],~op[2],~op[1], op[0]);
and(i_swc1, op[5], op[4], op[3],~op[2],~op[1], op[0]);
and (i_fadd,f_type,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
and (i_fsub,f_type,~func[5],~func[4],~func[3],~func[2],~func[1], func[0]);
and (i_fmul,f_type,~func[5],~func[4],~func[3],~func[2], func[1], ~func[0]);		
and (i_fdiv,f_type,~func[5],~func[4],~func[3],~func[2], func[1], func[0]);
and (i_fsqrt,f_type,~func[5],~func[4],~func[3],func[2],~func[1], ~func[0]);


wire i_rs = i_add | i_sub|i_and|i_or|i_xor|i_jr|i_addi|
			i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne |
			i_lwc1|i_swc1;
wire i_rt = i_add | i_sub|i_and|i_or|i_xor|i_sll|i_srl|
			i_sra|i_sw|i_beq|i_bne| i_mtc0;

assign stall_lw = ewreg & em2reg & (ern!=0) & (i_rs & (ern==rs)|
											i_rt & (ern==rt));			
reg [1:0] fwda,fwdb;
always @(ewreg or mwreg or ern or mrn or em2reg or mm2reg or rs or rt)begin
	fwda = 2'b00;
	if(ewreg&(ern!=0)&(ern==rs)&~em2reg)begin
		fwda = 2'b01;
	end else begin
		if(mwreg&(mrn!=0)&(mrn==rs)&~mm2reg)begin
			fwda = 2'b10;
		end else begin
			if(mwreg&(mrn!=0)&(mrn==rs)&mm2reg)begin
			fwda = 2'b11;
			end
		
		end
	end
	fwdb =  2'b00;
	if(ewreg & (ern != 0)&(ern == rt)&~em2reg)begin
		fwdb = 2'b01;
	end else begin
		if(mwreg & (mrn !=0) & (mrn == rt) & ~mm2reg)begin
			fwdb = 2'b10;
		end else begin
			if(mwreg & (mrn !=0) & (mrn == rt) & mm2reg)begin
				fwdb=2'b11;
			end
		
		end
	
	end
	
end

assign wreg =(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|
				 i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_jal)&wpcir ;
				 
	assign regrt= i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_lwc1;
	assign jal  = i_jal;
	assign m2reg=i_lw;
	assign shift=i_sll|i_srl|i_sra;
	assign aluimm = i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_sw|
				i_lwc1|i_swc1;
	assign sext =i_addi|i_lw|i_sw|i_beq|i_bne|i_lwc1|i_swc1;
	assign aluc[3]= i_sra;
	assign aluc[2]= i_sub|i_or|i_srl|i_sra|i_ori|i_lui;
	assign aluc[1]= i_xor|i_sll|i_srl|i_sra|i_xori|i_beq|i_bne|i_lui;
	assign aluc[0]= i_and|i_or|i_sll|i_srl|i_sra|i_andi|i_ori;
	assign wmem = (i_sw|i_swc1) & wpcir;
	assign pcsource[1]=i_jr|i_j|i_jal;
	assign pcsource[0]=i_beq&rsrtequ | i_bne&~rsrtequ |i_j|i_jal;		
		

	//fop: 000:fadd 001:fsub 01x:fmul 10x:fdiv 11x:fsqrt
	wire [2:0]fop;
	assign fop[0] = i_fsub;
	assign fop[1] = i_fmul;
	assign fop[2] = i_fdiv;	
	
	//stall caused by fp data harzards
	wire i_fs = i_fadd|i_fsub|i_fmul|i_fdiv|i_fsqrt;
	wire i_ft = i_fadd|i_fsub|i_fmul|i_fdiv;
	assign stall_fp = (e1w&(i_fs&(e1n==fs)|i_ft&(e1n==ft)))|
					  (e2w&(i_fs&(e2n==fs)|i_ft&(e2n==ft)));
	assign fwdfa = e3w &(e3n==fs);
	assign fwdfb = e3w &(e3n==ft);
	assign wfpr = i_lwc1&wpcir;
	assign fwdla = mwfpr & (mrn == rs);
	assign fwdlb = mwfpr & (mrn == rt);
	assign stall_lwc1 = ewfpr &(i_fs & (ern == fs)|i_ft &(ern == ft));
	assign swfp = i_swc1;
	assign fwdf = swfp & e3w & (ft == e3n);
	assign fwdfe = swfp & e2w & (ft == e2n);
	assign stall_swc1 = swfp & e1w & (ft == e1n);
	assign wpcir = ~(stall_div_sqrt|stall_others);
	wire stall_others = stall_lw |stall_fp|stall_lwc1|stall_swc1|st;
	assign fc = fop & {3{~stall_others}};
	assign wf = i_fs & wpcir;
	assign fasmds = i_fs;
											
endmodule