module mccu(op,func,z,clock,resetn,
			wpc,wir,wmem,wreg,iord,regrt,m2reg,aluc,
			shift,alusrca,alusrcb,pcsource,jal,sext,state);
input [5:0] op,func;
input z,clock,resetn;
output reg [3:0]aluc;
output reg [1:0]alusrcb,pcsource;
output reg shift,alusrca,jal,sext;
output reg [2:0] state;

reg[2:0] next_state;
parameter [2:0] sif = 3'b000;
				sid = 3'b001;
				sexe= 3'b101;
				smem =3'b011;
				swb = 3'b100;

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
and (i_addi,~op[5],~op[4], op[3],~op[2],~op[1],~op[0]);
and (i_andi,~op[5],~op[4], op[3], op[2],~op[1],~op[0]);
and (i_ori ,~op[5],~op[4], op[3], op[2],~op[1],op[0]);
and (i_xori,~op[5],~op[4], op[3], op[2], op[1],~op[0]);
and (i_lw, op[5],~op[4],~op[3],~op[2], op[1],op[0]);
and (i_sw, op[5],~op[4], op[3],~op[2], op[1],op[0]);
and (i_beq,~op[5],~op[4],~op[3],op[2],~op[1],~op[0]);
and (i_bne,~op[5],~op[4],~op[3],op[2],~op[1], op[0]);
and (i_lui,~op[5],~op[4], op[3], op[2], op[1],op[0]);
and (i_j,~op[5],~op[4],~op[3],~op[2], op[1],~op[0]);
and (i_jal,~op[5],~op[4],~op[3],~op[2], op[1], op[0]);
wire  i_shift;
or (i_shift,i_sll,i_srl,i_sra);
always @(*)begin
	wpc = 0;
	wir = 0;
	wmem = 0;
	wreg = 0;
	iord = 0;
	aluc = 4'bx000;
	alusrca = 0;
	alusrcb = 2'h0;
	regrt = 0;
	m2reg = 0;
	shift = 0;
	pcsource = 2'h0;
	jal = 0;
	sext = 1;

	case(state)
	//---------------------------------------------IF
	sif:begin
		wpc = 1;
		wir =1;
		alusrca = 1;
		alusrcb = 2'h1;
		next_state = sid;
	end
	//---------------------------------------------ID
	sid:begin
		if(i_j)begin
			pcsource = 2'h3;
			wpc = 1;
			next_state = sif;
		end
		else if(i_jr)begin
			pcsource = 2'h2;
			wpc = 1;
			next_state = sif;
		end else begin
			aluc = 4'bx000;
			alusrca = 1;
			alusrcb = 2'h3;
			next_state = sexe;
		end
	end
	//---------------------------------------------EXE
	sexe:begin
	aluc[3] = i_sra;
	aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_lui;
	aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq |
			i_bne | i_lui;
	aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi |
			i_ori;
	if(i_beq || i_bne )begin
		pcsource = 2'h1;
		wpc = i_beq &z|i_bne&~z;
		next_state = sif;
	end
	else begin
		if(i_lw||i_sw)begin
			aluscrb = 2'h2;
			next_state = smem;
		end else begin
			if(i_shift)shift = 1;
			if(i_addi||i_andi}}i_ori||i_xori||i_lui)
				alusrcb = 2'h2;
			if(i_andi||i_ori||i_xori)sext=0;
			next_state = swb;
		end
	end
	end
	//---------------------------------------------MEM
	smem: begin
		iord = 1;
		if(i_lw)begin
			next_state = swb;
		end else begin
			wmem = 1;
			next_state = sif;
		end
	end
	//---------------------------------------------WB
	swb:begin
		if(i_lw)m2reg = 1;
		if(i_lw||i_addi||i_andi||i_ori||i_xori||i_lui)
			regrt = 1;
		wreg = 1;
		next_state = sif;
	end
	//---------------------------------------------END
	default:begin
		next_state = sif;
	end

	endcase
	
end

always @(posedge clock or negedge resetn)begin
	if(resetn ==0)begin
		state<=sif;
	end
	else begin
		state<=next_state;
	end
end	


endmodule