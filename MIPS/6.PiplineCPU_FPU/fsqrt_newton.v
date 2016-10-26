`include "shift_even_bits.v"
`include "root_newton24.v"
module fsqrt_newton (d,rm,fsqrt,enable,clock,resetn,
					s,busy,stall,count,reg_x);
	   input [31:0] d;
	   input [1:0] rm;
	   input fsqrt;
	   input enable,clock,resetn;
	   output [31:0] s;
	   output busy;
	   output stall;
	   output [4:0] count;
	   output [25:0] reg_x;
	   parameter ZERO = 31'h0;
	   parameter INF = 31'h7f800000;
	   parameter NaN = 31'h7fc00000;
	   parameter MAX = 31'h7f7fffff;
	   
	   wire d_expo_is_00 = ~|d[30:23];
	   wire d_expo_is_ff = &d[30:23];
	   wire d_frac_is_00 = ~|d[22:0];
	   wire sign = d[31];
	   
	   wire [7:0]exp_8 = {1'b0,d[30:24]} + 8'h3f + d[23];
	   wire [23:0] d_f24 = d_exp_is_00? {d[22:0],1'b0}:{1'b1,d[22:0]};
	   wire [23:0] d_temp24 = d[23]? {1'b0,d_f24[23:1]} : d_f24;
	   
	   wire [23:0] d_frac24;
	   wire [4:0] shamt_d;
	   shift_even_bits shift_d (d_temp24,d_frac24,shamt_d);
	   wire[7:0] exp0 = exp_8 - {4'h0,shamt_d[4:1]};
	   
	   reg e1_sign,e1_e00,e1_eff,e1_f00; 
	   reg e2_sign,e2_e00,e2_eff,e2_f00;
	   reg e3_sign,e3_e00,e3_eff,e3_f00;
	   reg [1:0] e1_rm,e2_rm,e3_rm;
	   reg [7:0] e1_exp,e2_exp,e3_exp;
	   always @(negedge resetn or posedge clock)begin
		if(resetn == 0)begin
			e1_sign<=0;e2_sign<=0;e3_sign<=0;
			e1_rm <=0; e2_rm <=0; e3_rm <=0;
			e1_exp<=0; e2_exp<=0;e3_exp<=0;
			e1_e00<=0; e2_e00<=0; e3_e00<=0;
			e1_eff<=0; e2_eff<=0; e3_eff<=0;
			e1_f00<=0; e2_f00<=0; e3_f00<=0;
		end else if(enable)begin
			e1_sign<=sign;			e2_sign<=e1_sign;	e3_sign<=e2_sign;
			e1_rm <=rm; 			e2_rm <=e1_rm; 		e3_rm <=e2_rm;
			e1_exp<=exp0; 			e2_exp<=e1_exp;		e3_exp<=e2_exp;
			e1_e00<=d_expo_is_00; 	e2_e00<=e1_e00; 	e3_e00<=e2_e00;
			e1_eff<=d_expo_is_ff; 	e2_eff<=e1_eff; 	e3_eff<=e2_eff;
			e1_f00<=d_frac_is_00; 	e2_f00<=e1_f00; 	e3_f00<=e2_f00;
			
		end
	   end
	   
	   root_newton24 frac_newton (d_frac24,fsqrt,enable,clock,resetn,
								frac0,busy,count,reg_x,stall);
		wire [31:0] frac0;
		wire [26:0] frac = {frac0[31:6],|frac0[5:0]};
		
		
		wire frac_plus_1 = 
		~e3_rm[1] & ~e3_rm[0] & frac[3] & frac[2] & ~frac[1] & ~frac[0]|
		~e3_rm[1] & ~e3_rm[0] & frac[2] & (frac[1] | frac[0]) |
		~e3_rm[1] &  e3_rm[0] & (frac[2] | frac[1] | frac[0]) & e3_sign |
		 e3_rm[1] & ~e3_rm[0] & (frac[2] | frac[1] | frac[0]) & ~e3_sign;
	
	wire [24:0] frac_round = {1'b0,frac[26:3]} + frac_plus_1;
	wire [9:0] exp1 = frac_round[24]? e3_exp +8'h1;
	wire overflow = (exp1 >= 10'h0ff);

	wire [7:0] exponent;
	wire [22:0] fraction;
	assign {exponent,fraction} = final_result(overflow,e3_rm,e3_sign,e3_sign,e3_e00,
			e3_eff,e3_f00,e3_be00,e3_bf00,{exp1[7:0],frac_round[22:0]});
	assign s = {e3_sign,exponent,fraction}};
	
	
	function [30:0] final_result;
		input overflow;
		input [1:0] e3_rm;
		input e3_sign;
		input d_sign,d_e00,d_eff,d_f00;
		input [30:0] calc;
		casex ({overflow,e3_rm,e3_sign,d_sign,d_e00,d_eff,d_f00})
			8'b100x_xxxx: final_result = INF;
			8'b1010_xxxx: final_result = MAX;
			8'b1011_xxxx: final_result = INF;
			8'b1100_xxxx: final_result = INF;
			8'b1101_xxxx: final_result = MAX;
			8'b111x_xxxx: final_result = MAX;
			8'b0xxx_1xxx: final_result = NaN;
			8'b0xxx_0010: final_result = NaN;
			8'b0xxx_0011: final_result = INF;
			8'b0xxx_0101: final_result = ZERO;
			8'b0xxx_000x: final_result = calc;
			8'b0xxx_0100: final_result = calc;
			default:      final_result = NaN;
			endcase
	endfunction
	
endmodule 
