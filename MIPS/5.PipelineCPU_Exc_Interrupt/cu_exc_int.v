module cu_exc_int(mwreg,mrn,ern,ewreg,em2reg,mm2reg,rsrtequ,func,op,rs,rt,
				rd,op1,wreg,m2reg,wmem,aluc,regrt,aluimm,fwda,fwdb,
				wpcir,sext,pcsource,shift,jal,intr,sta,ecancel,ov,
				earith,eisbr,misbr,inta,selpc,exc,sepc,cause,mtc0,wepc,
				wcau,wsta,mfc0,isbr,arith,cancel);
input mwreg,ewreg,em2reg,mm2reg,rsrtequ;
input [4:0] mrn,ern,rs,rt,rd,op1;
input	[5:0] func,op;
output 	wreg,m2reg,wmem,regrt,aluimm,sext,shift,jal;
output [3:0] aluc;
output [1:0] pcsource;
output [1:0] fwda,fwdb;
output wpcir;

//new for interrupt /exception
input intr,ecancel,ov,earith,eisbr,misbr;
input [31:0] sta;
output [1:0] selpc,mfc0,sepc;
output [31:0] cause;

assign isbr = i_beq |i_bne|i_j|i_jal;
assign arith = i_add|i_sub|i_addi;
wire overflow = ov&earith;
assign inta = exc_int;
wire exc_int = sta[0]&intr;
wire exc_sys = sta[1]&intr;
wire exc_uni = sta[2] &unimplimented_inst;
wire exc_ovr = sta[3] & overflow;
assign exc = exc_int|exc_sys|exc_uni|exc_ovr;
assign cancel = exc;
assign sepc[1]=exc_uni&eisbr|exc_ovr;
assign sepc[0] = exc_int&isbr|exc_sys|
				exc_uni&~eisbr|exc_ovr&misbr;
//ExcCode
//0 0:intr
//0 1:i_syscall
//1 0:unimplimented_inst
//1 1:overflow
wire ExcCode0 = i_syscall|overflow;
wire ExcCode1 = unimplimented_inst|overflow;
assign cause = {eisbr,27'h0,ExcCode1,ExcCode0,2'b00};
assign mtc0 = i_mtc0;
assign wsta = exc | mtc0& rd_is_status|i_eret;
assign wcau = exc |mtc0 &rd_is_cause;
assign wepc = exc |mtc0 & rd_is_epc;
wire rd_is_status = (rd==5'd12);
wire rd_is_cause = (rd==5'd13);
wire rd_is_epc = (rd==5'd14);

//mfc0
//0 0:pc+8
//0 1:sta
//1 0:cau
//1 1:epc
assign mfc0[0]=i_mfc0 & rd_is_status;
assign mfc0[1]=i_mfc0 & rd_is_cause;

//selpc
//0 0:npc
//0 1:epc
//1 0:EXC_BASE
//1 1:x
assign selpc[0] = i_eret;
assign selpc[1] =exc;

wire c0_type = ~op[5] & op[4] & ~op[3]& ~op[2]& ~op[1]& ~op[0];
wire i_mfc0 = c0_type & ~op1[4] & ~op1[3]& ~op1[2]& ~op1[1]& ~op1[0];
wire i_mtc0 = c0_type & ~op1[4] & ~op1[3]&  op1[2]& ~op1[1]& ~op1[0];
wire i_eret = c0_type &  op1[4] & ~op1[3]&  op1[2]& ~op1[1]& ~op1[0]&
				~func[5]& func[4]& func[3]&~func[2]&~func[1]&~func[0];
wire i_syscall = r_type & ~func[5]& ~func[4]& func[3]& func[2]&~func[1]&~func[0];

wire unimplimented_inst = ~(i_mfc0|i_mtc0|i_eret|i_syscall|i_add|i_sub|i_and|i_or|
					i_xor|i_sll|i_srl|i_sra|i_jr|i_addi|i_andi|i_ori|i_xori|i_lw|
					i_sw|i_beq|i_bne|i_lui|i_j|i_jal);
	
			
wire r_type,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;
wire i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
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

wire i_rs = i_add | i_sub|i_and|i_or|i_xor|i_jr|i_addi|
			i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne;
wire i_rt = i_add | i_sub|i_and|i_or|i_xor|i_sll|i_srl|
			i_sra|i_sw|i_beq|i_bne|i_mtc0;
			
assign wpcir = ~(ewreg & em2reg & (ern !=0) &(i_rs & (eern == rs)|
							i_rt & (ern == rt)));


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
		if(mwreg & (mrn !=0) & (mrn == rt) & mm2reg)begin
			fwdb = 2'b10;
		end else begin
			if(mwreg & (mrn !=0) & (mrn == rt) & mm2reg)begin
				fwdb=2'b11;
			end
		
		end
	
	end
	
end

assign wmem = i_sw & wpcir & ~ecancel & ~exc_ovr ;
assign wreg =(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|
				 i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_jal|i_mfc0)&
				 wpcir & ~ecancel & ~exc_ovr;
				 
	assign regrt= i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_mfc0;
	assign jal  = i_jal;
	assign m2reg=i_lw;
	assign shift=i_sll|i_srl|i_sra;
	assign aluimm = i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_sw;
	assign sext =i_addi|i_lw|i_sw|i_beq|i_bne;
	assign aluc[3]= i_sra;
	assign aluc[2]= i_sub|i_or|i_srl|i_sra|i_ori|i_lui;
	assign aluc[1]= i_xor|i_sll|i_srl|i_sra|i_xori|i_beq|i_bne|i_lui;
	assign aluc[0]= i_and|i_or|i_sll|i_srl|i_sra|i_andi|i_ori;
	
	assign pcsource[1]=i_jr|i_j|i_jal;
	assign pcsource[0]=i_beq&rsrtequ | i_bne&~rsrtequ |i_j|i_jal;
	
endmodule
