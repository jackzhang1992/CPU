module iu_cache_tlb(e1n,e2n,e3n,e1w,e2w,e3w,stall,st,
			dfb,e3d,clock,memclock,resetn,no_cache_stall,
			fs,ft,wmo,wrn,wwfpr,mmo,fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,
			fasmds,v_pc,pc,inst,ealu,malu,walu,
			stall_lw,stall_fp,stall_lwc1,stall_swc1,mem_a,
			mem_data,mem_st_data,mem_access,mem_write,mem_ready
	);
	input [31:0] dfb,e3d;
	input [4:0] e1n,e2n,e3n;
	input e1w,e2w,e3w,stall,st,clock,memclock,resetn;
	output no_cache_stall;
	output [31:0] v_pc,oc,inst,ealu,malu,walu;
	output [31:0] mmo,wmo;
	output [4:0] fs,ft,fd,wrn;
	output [2:0] fc;
	output wwfpr,fwdla,fwdlb,fwdfa,fwdfb,wf,fasmds;
	output stall_lw,stall_fp,stall_lwc1,stall_swc1;
	output [31:0] mem_a;
	output [31:0] mem_data;
	output [31:0]mem_st_data;
	output mem_access;
	output mem_write;
	output mem_ready;
	
	parameter EXC_BASE = 32'h80000008;
	wire [31:0] bpc,jpc,npc,pc4,ins,dpc4,inst,qa,qb,da,db,dimm,dc,dd;
	wire [31:0] simm,epc8,alua,alub,ealu0,ealu1,ealu,sa,eb,mmo,wdi;
	wire [5:0] op,func;
	wire [4:0] rs,rt,rd,fs,ft,fd,drn,ern;
	wire [3:0] aluc;
	wire [1:0] pcsource,fwda,fwdb;
	wire wpcir;
	wire wreg,m2reg,wmem,aluimm,shift,jal;
	wire [31:0] qfa,qfb,fa,dfa,dfb,efb,e3d;
	wire [4:0] e1n,e2n,e3n,wn;
	wire [2:0] fc;
	wire [1:0] e1c,e2c,e3c;
	reg ewfpr,ewreg,em2reg,ewmem,ejal,efwdfe,ealuimm,eshift;
	reg mwfpr,mwreg,mm2reg,mwmem;
	reg wwfpr,wwreg,wm2reg;
	reg [31:0] epc4,ea,ed,eimm,malu,mb,wmo,walu;
	reg [4:0] ern0,mrn,wrn;
	reg [3:0] ealuc;
	//IF
	p_c vpc (next_pc,clock,resetn,wpcir & no_cache_stall,v_pc);
	cla32 pc_plus4(v_pc,32'h4,1'b0,pc4);
	mux4x32 nextpc(pc4,bpc,da,jpc,pcsource,npc);
	wire tlbwi,tlbwr;
	wire itlbwi = tlbwi & ~ index[30];
	wire itlbwr = tlbwr & ~ index[30];
	wire dtlbwi = tlbwi & index[30];
	wire dtlbwr = tlbwr & index[30];
	
	wire [19:0] ipattern = (itlbwi | itlbwr)?enthi[19:0] : v_pc[31:12];
	wire pc_unmapped = v_pc[31] & ~v_pc[30];
	assign pc = pc_unmapped? {1'b0,v_pc[30:0]} : {ipte_out[19:0],v_pc[11:0]};
	wire [2:0] irandom;
	wire [23:0] ipte_out;
	wire itlb_hit;
	wire [2:0] ivpn_index;
	wire ivpn_found;
	tlb_8_entry itlb(entlo[23:0],itlbwi,itlbwr,index[2:0],ipattern,
				memclock,clock,resetn,
				irandom,ipte_out,itlb_hit,ivpn_index,ivpn_found);
	wire itlb_exc = ~itlb_hit & ~pc_unmapped;
	wire i_ready,i_cache_miss;
	i_cache icache(pc,ins,1'b1,i_ready,i_cache_miss,clock,resetn,
					m_i_a,mem_data,m_fetch,m_i_ready);
	//IF- ID
	dffe32 pc_4_r(pc4,clock,resetn,wpcir & no_cache_stall,dpc4);
	dffe32 inst_r(ins,clock,resetn,wpcir & no_cache_stall,inst);
	dffe32 pcd_r (v_pc,clock,resetn,wpcir & no_cache_stall,pcd);
	wire [31:0]pcd;
	
	//ID
	assign op = inst[31:26];
	assign rs = inst[25:21];
	assign rt = inst [20:16];
	assign rd = inst [15:11];
	assign ft = inst [20:16];
	assign fs = inst [15:11];
	assign fd = inst [10:6];
	assign func = inst[5:0];
	assign simm = {{16{sext&inst[15]}},inst[15:0]};
	assign jpc = {dpc4[31:28],inst[25:0],2'b00};
	cla32 br_addr(dpc4,{simm[29:0],2'b00},1'b0,bpc);
	regfile rf(rs,rt,wdiwrn,wwreg,~clock,resetn,qa,qb);
	mux4x32 alu_a(qa,ealu,malu,mmo,fwda,da);
	mux4x32 alu_b(qa,ealu,malu,mmo,fwdb,db);
	wire swfp,regrt,sext,fwdf,fwdfe,wfpr;
	mux2x32 store_f(db,dfb,swfp,dc);
	mux2x32 fwd_f_d(dc,e3d,fwdf,dd);
	wire rsrtequ = ~|(da^db);
	mux2x5 des_reg_no(rd,rt,regrt,drn);
	control cu (op,func,rs,rt,fs,ft,rsrtequ,
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
	wire [31:0] index;
	wire [31:0] entlo;
	wire [31:0] contx;
	wire [31:0] enthi;
	wire windex,wentlo,wcontx,wenthi;
	wire rc0,wc0;
	wire [1:0] c0rn;
	dffe32 c0_Index (db,clock,resetn,windex & no_cache_stall,index);
	dffe32 c0_Entlo (db,clock,resetn,wentlo & no_cache_stall,entlo);
	dffe32 c0_Enthi (db,clock,resetn,enthi & no_cache_stall,enthi);
	always @(negedge resetn or posedge clock)begin
		if(resetn ==0)begin
			contx <= 0;
		end else begin
			if(wcontx) contx [31:22] <= db[31:22];
			if(itlb_exc) contx[21:0] <={v_pc[31:12],2'b00};
			else if(dtlb_exc)contx[21:0] <= {malu[31:12],2'b00};
		end
		
	wire [31:0] sta,cau,epc,sta_in,cau_in,epc_in,
				stalr,epcin,epc10,cause,c0reg,next_pc;
	dffe32 c0_Status (sta_in,clock,resetn,wsta & no_cache_stall,sta);
	dffe32 c0_Cause (cau_in,clock,resetn,wcau&no_cache_stall,cau);
	dffe32 c0_EPC(epc_in,clock,resetn,wepc&no_cache_stall,epc);
	mux2x32 sta_mx(stalr,db,mtc0,sta_in);
	mux2x32 cau_mx(cause,db,mtc0,cau_in);
	mux2x32 epc_mx(epcin,db,mtc0,epc_in);
	mux2x32 sta_lr({8'h0,sta[31:8]},{sta[23:0],8'h0},exc,stalr);
	mux4x32 epc_04(v_pc,pcd,pcm,pcw,sepc,epcin);
	mux4x32 irq_pc(npc,epc,EXC_BASE,32'h0,selpc,next_pc);
	mux4x32 fromc0(contx,sta,cau,epc,ec0rn,c0reg);
	//ID-EXE
	reg [31:0] pce;
	reg [1:0] ec0rn;
	reg erc0,ecancel,eisbr,eldst;
	always @(negedge resetn or posedge clock)begin
		if(resetn==0)begin
			ewfpr<=0;		ewreg<=0;	
			em2reg<=0;		ewmem<=0;
			ejal<=0;		ealuimm<=0;
			efwdfe<=0;		ealuc<=0;
			eshift<=0;		epc4<=0;
			ea<=0;			ed<=0;
			eimm<=0;		ern0<=0;
			erc0<=0;		ec0rn<=0;
			ecancel<=0;		eisbr<=0;
			pce<=0;			eldst<=0;
				
		end else if(no_cache_stall)begin
			ewfpr<=wfpr;		ewreg<=wreg;	
			em2reg<=m2reg;		ewmem<=wmem;
			ejal<=jal;			ealuimm<=aluimm;
			efwdfe<=fwdfe;		ealuc<=aluc;
			eshift<=shift;		epc4<=dpc4;
			ea<=da;				ed<=dd;
			eimm<=simm;			ern0<=drn;
			erc0<=rc0;			ec0rn<=c0rn;
			ecancel<=cancel;	eisbr<=isbr;
			pce<=pcd;			eldst<=ldst;
					
		end
	end
	//EXE
	cla32 ret_addr(epc4,32'h4,1'b0,epc8);
	assign sa = {eimm[5:0],eimm[31:6]};
	mux2x32 alu_ina(ea,sa,eshift,alua);
	mux2x32 alu_inb (eb,eimm,ealuimm,alub);
	mux2x32 save_pc8(ealu0,epc8,ejal,ealu1);
	mux2x32 read_cr0(ealu1,	c0reg,erc0,ealu);
	wire z;
	alu a1_unit (alua,alub,ealuc,ealu0,z);
	assign ern = ern0 | {5{ejal}};
	mux2x32 fwd_f_e(ed,e3d,efwdfe,eb);
	//EXE-MEM
	reg [31:0] pcm;
	reg misbr,mldst;
	always @(negedge resetn or posedge clock)begin
		if(resetn == 0)begin
			mwfpr<=0;		mwreg<=0;
			mm2reg<=0;		mwmem<=0;
			malu<=0;		mb<=0;
			mrn<=0;			misbr<=0;
			pcm<=0;			mldst<=0;
			
		end else if (no_cache_stall)begin
			mwfpr<=ewfpr & ~dtlb_exc;		
			mwreg<=ewreg&~dtlb_exc;		
			mwmem<=ewmem&~dtlb_exc;		
			mldst<=eldst&~dtlb_exc;			
			mm2reg<=em2reg;
			malu<=ealu; 		mb<= eb;
			mrn<=ern;
			misbr<=misbr;
			pcm<=pce;
			
		
		end
	
	end
	
	//MEM
	wire [19:0] dpattern = (dtlbwi|dtlbwr)?enthi[19:0] : malu[31:12];
	wire ma_unmapped = malu[31]&~malu[30];
	wire [31:0] m_addr = ma_unmapped?{1'b0,malu[30:0]} : {dpte_out[19:0],malu[11:0]};
	wire [2:0] drandom;
	wire [23:0] dpte_out;
	wire  dtlb_hit;
	wire [2:0] dvpn_index;
	wire dvpn_found;
	tlb_8_entry dtlb(entlo[23:0],dtlbwi,dtlbwr,index[2:0],dpattern,
			memclock,clock,resetn,
			drandom,dpte_out,dtlb_hit,dvpn_index,dvpn_found);
	wire dtlb_exc = ~ dtlb_hit & ~ ma_unmapped & mldst;
	wire 	d_ready;
	wire w_mem = mwmem & ~ dtlb_exc;
	d_cache dcache(m_addr,mb,mmo,mldst,w_mem,d_ready,clock,resetn,
			m_d_a,mem_data,mem_st_data,m_ld_st,m_st,m_d_ready);
	
	//MEM-WB
	reg [31:0] pcw;
	reg 	wisbr;
	always @(negedge resetn or posedge clock)begin
		if(resetn==0)begin
			wwfpr<=0;		wwreg<=0;
			wm2reg<=0;		wmo<=0;
			walu<=0;		wrn<=0;
			pcw<=0;			wisbr<=0;
			
		end else if(no_cache_stall) begin
		wwfpr<= mwfpr & ~ dtlb_exc;
		wwreg<= mwreg & ~dtlb_exc;
		wm2reg<= mm2reg;	wmo<=mmo;
		walu<=malu;			wrn<=mrn;
		pcw	<pcm;			wisbr<=misbr;
		
		end
		
	end
	
	//WB 
	mux2x32 wb_sel(walu,wmo,wm2reg,wdi);
	//for main_memory access
	wire 	m_fetch,m_ld_st,m_st;
	wire [31:0] m_i_a, m_d_a;
	//mux	
	wire sel_i = i_cache_miss;
	assign mem_a = sel_i? m_i_a : m_d_a;
	assign mem_access = sel_i ? m_fetch : m_ld_st;
	assign mem_write = sel_i? 1'b0 :m_st;
	//demux
	wire m_i_ready = mem_ready & sel_i;
	wire m_d_ready = mem_ready & ~sel_i;
	assign no_cache_stall = ~(~i_ready | mldst & ~ d_ready);
	 
endmodule
