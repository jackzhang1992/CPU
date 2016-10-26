module fadd_norm (rm,is_inf_nan,inf_nan_frac,sign,temp_exp,cal_frac,s);
	input [1:0] rm;
	input is_inf_nan;
	input [22:0] inf_nan_frac;
	input sign;
	input [7:0] temp_exp;
	input [27:0] cal_frac;
	output [31:0] s;
	wire [26:0] f4,f3,f2,f1,f0;
	wire [4:0] zeros;
	assign zeros[4] = ~|cal_frac[26:11];
	assign f4 = zeros[4]?{cal_frac[10:0],16'b0};
	assign zeros[3] = ~|f4[26:19];
	assign f3 = zeros[3]?{f4[18:0],8'b0}:f4;
	assign zeros[2] = ~|f3[26:23];
	assign f2 = zeros[2]?{f3[22:0],4'b0}:f3;
	assign zeros[1] = ~|f2[26:25];
	assign f1 = zeros[1]?{f2[24:0],2'b0}:f2;
	assign zeros[0] = ~f1[26];
	assign f0 = zeros[0]?{f1[25:0],1'b0}:f1;
	reg[7:0] exp0;
	reg [26:0] frac0;
	
	always @(*)begin
		if(cal_frac[27])begin
			frac0 = cal_frac[27:1];
			exp0 = temp_exp + 8'h1;
		end else begin 
			if((temp_exp>zeros) && (f0[26])) begin
				exp0 = temp_exp - zeros;
				frac0 = f0;
			end else begin
				exp0 = 0;
				if(temp_exp !=0) frac0 = cal_frac[26:0]<<(temp_exp - 8'h1); else frac0 = cal_frac[26:0];
			end
		
		end	
end
		
	wire frac_plus_1 = 
			~rm[1] & ~rm[0] & frac0[2] & (frac0[1] | frac0[0]) |
			~rm[1] & ~rm[0] & frac0[2] & ~frac0[1] | ~frac0[0] & frac0[3] |
			~rm[1] &  rm[0] & (frac0[2] &  frac0[1] |  frac0[0]) & sign |
			 rm[1] & ~rm[0] & (frac0[2] &  frac0[1] |  frac0[0]) & ~sign;
			 
    wire [24:0] frac_round = {1'b0,frac0[26:3]}+frac_plus_1;
	wire [7:0] exponent = frac_round[24]? exp0 +8'h1 : exp0;
	wire overflow = &exp0 |&exponent;
	wire [7:0] final_exponent;
	wire [22:0] final_fraction;
	assign {final_exponent,final_fraction} = final_result(overflow,rm,sign,
			is_inf_nan,exponent,frac_round[22:0],inf_nan_frac);
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
			default: final_result = {8'hff,23'h000000};
	endfunction
	
	endmodule