module fmul_norm(rm,sign,exp10,is_inf_nan,
					inf_nafrac,z,s);
		input [1:0]rm;
		input  sign;
		input  [9:0] exp10;
		input  is_inf_nan;
		input  [22:0] inf_nan_frac;
		input [47:0] z;
		output [31:0]s;
		wire [46:0] z5,z4,z3,z2,z1,z0;
		wire [5:0] zeros;
		
	assign zeros[5] = ~|z[46:15];
	assign z5 = zeros[5]?{z[14:0],32'b0}: z[46:0];
	assign zeros[4] = ~|z5[46:31];
	assign z4 = zeros[4]?{z5[30:0],16'b0} :z5;
	assign zeros[3] = ~|z4[46:39];
	assign z3 = zeros[3]? {z4[38:0],8'b0} :z4;
	assign zeros[2] = ~|z3[46:43];
	assign z2 = zeros[2]? {z3[42:0],4'b0} :z3;
	assign zeros[1] = ~|z2[46:45];
	assign z1 = zeros[1]? {z2[44:0],2'b0} :z2;
	assign zeros[0] = ~z1[46];
	assign z0 = zeros[0]? {z1[45:0],1'b0} :z1;
	reg[9:0] exp0;
	reg [46:0] frac0;
	
always @(*)begin
		if(z[47])begin
			exp0 = exp10 + 10'h1;
			frac0 = z[47:1];
		end else begin 
			if(! exp10[9] && (exp10[8:0]>zeros) & z0[46]) begin
				exp0 = exp10 - zeros;
				frac0 = z0;
			end else begin
				exp0 = 0;
				if(!exp10[9] && (exp10 !=0 )) frac0 = z[46:0] <<(exp10 -10'h1); else frac0 = z[46:0] >> (10'h1 - exp10);
			end
		
		end	
end
	wire [26:0]frac = {frac0[46:21],|frac0[20:0]};
	
	wire frac_plus_1 = 
			~rm[1] & ~rm[0] & frac0[2] & (frac0[1] | frac0[0]) |
			~rm[1] & ~rm[0] & frac0[2] & ~frac0[1] & ~frac0[0] & frac0[3] |
			~rm[1] &  rm[0] & (frac0[2] | frac0[1] |  frac0[0]) & sign |
			 rm[1] & ~rm[0] & (frac0[2] |  frac0[1] |  frac0[0]) & ~sign;
			 
    wire [24:0] frac_round = {1'b0,frac[26:3]}+frac_plus_1;
	wire [9:0] exp1 = frac_round[24]? exp0 +10'h1 : exp0;
	wire overflow = (exp0>=10'h0ff) |(exp1 >=10'h0ff);
	wire [7:0] final_exponent;
	wire [22:0] final_fraction;
	assign {final_exponent,final_fraction} = final_result(overflow,rm,sign,
			is_inf_nan,exp1[7:0],frac_round[22:0],inf_nan_frac);
	assign s = {sign,final_exponent,final_fraction};
	function [30:0] final_result;
		input overflow;
		input [1:0] rm;
		input sign,is_inf_nan;
		input [7:0] exponent;
		input [22:0] fraction,inf_nan_frac;
		casex ({overflow,rm,sign,is_inf_nan})
			5'b1_00_x_x:final_result = {8'hff,23'h000000};
			5'b1_01_0_x:final_result = {8'hfe,23'h7fffff};
			5'b1_01_1_x:final_result = {8'hff,23'h000000};
			5'b1_10_0_x:final_result = {8'hff,23'h000000};
			5'b1_10_1_x:final_result = {8'hfe,23'h7fffff};
			5'b1_11_x_x:final_result = {8'hfe,23'h7fffff};
			5'b0_xx_x_0:final_result = {exponent,fraction};
			5'b0_xx_x_1:final_result = {8'hff,inf_nan_frac};
			default: final_result = {8'h00,23'h000000};
	endfunction
endmodule
