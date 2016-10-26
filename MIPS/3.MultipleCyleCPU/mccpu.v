`include "mccu.v"
`include "dffe32.v"
`include "dff32.v"
`include "mux2x5.v"
`include"mux2x32.v"
`include"mux4x32.v"
`include "regfile.v"
`include "alu.v"

module mccpu(clock,resetn,frommem,pc,inst,alua,alub,alu,wmem,madr,tomem,state);
	input [31:0] frommem;
	input clock,resetn;
	output [31:0] pc,inst,alua,alub,alu,madr,tomem;
	output [2:0] state;
	output wmem;
	wire [3:0]aluc;
	wire [4:0]reg_dest;
	wire z,wpc,wir,wmem,wreg,iord,regrt,m2reg,shift,selpc,jal,sext;
	wire [31:0]npc,rega,regb,regc,mem,qa,qb,res,opa,bra,alub,alu_mem;
	wire [1:0] alusrcb,pcsource;
	wire [31:0] sa = {27'b0,inst[10:6]};
	mccu control_unit (inst[31:26],inst[5:0],z,clock,resetn,
			wpc,wir,wmem,wreg,iord,regrt,m2reg,aluc,
			shift,selpc,alusrcb,pcsource,jal,sext,state);
		
	wire e = sext & inst[15];
	wire [15:0] imm = {16{e}};
	wire [31:0] immediate = {imm[13:0],inst[15:0],1'b0,1'b0};
	dffe32 ip(npc,clock,resetn,wpc,pc);
	dffe32 ir (frommem,clock,resetn,wir,inst);
	dff32  dr (frommem,clock,resetn,mem);
	dff32  ra (qa,clock,resetn,rega);
	dff32  rb (qb,clock,resetn,regb);
	dff32  rc (alu,clock,resetn,regc);
	
	assign tomem = regb;
	mux2x5 reg_wn (inst[15:11],inst[20:16],regrt,reg_dest);
	wire [4:0] wn =regrt | {5{jal}};
	mux2x32 mem_address (pc,regc,iord,madr);
	mux2x32 result (regc,mem,m2reg,alu_mem);
	mux2x32 link (alu_mem,pc,jal,res);
	mux2x32 oprand_a (rega,sa,shift,opa);
	mux2x32 alu_a (opa,pc,selpc,alua);
	mux4x32 alu_b (regb,32'h4,immediate,offset,alusrcb,alub);
	mux4x32 nextpc (alu,regc,qa,jpc,pcsource,npc);
	regfile rf (inst[25:21],inst[20:16],res,wn,wreg,clock,resetn,qa,qb);
	wire [31:0] = {pc[31:28],isnt[25:0],1'b0,1'b0};
	alu alunit(alua,alub,aluc,alu,z);
	
endmodule
