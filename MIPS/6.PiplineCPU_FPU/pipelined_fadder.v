`include "fadd_align.v"
`include "reg_align_cal.v"
`include "fadd_cal.v"
`include "reg_cal_norm.v"
`include "fadd_norm.v"

module pipelined_fadder(a,b,sub,rm,s,clock,clrn,e);
	input [31:0]a,b;
	input sub;
	input e;
	input [1:0] rm;
	input clock,clrn;
	output [31:0] s;
	wire [1:0] a_rm;
	wire a_is_inf_nan;
	wire [22:0] a_inf_nan_frac;
	wire a_sign;
	wire [7:0] a_exp;
	wire a_op_sub;
	wire [23:0] a_large_frac;
	wire [26:0] a_small_frac;
	fadd_align alignment(a,b,sub,a_is_inf_nan,a_inf_nan_frac,a_sign,
			a_exp,a_op_sub,a_large_frac,a_small_frac);
	

	wire [1:0] c_rm;
	wire c_is_inf_nan;
	wire [22:0] c_inf_nan_frac;
	wire c_sign;
	wire [7:0] c_exp;
	wire c_op_sub;
	wire [23:0] c_large_frac;
	wire [26:0] c_small_frac;
	reg_align_cal reg_ac(rm,a_is_inf_nan,a_inf_nan_frac,a_sign,a_exp,
						a_op_sub,a_large_frac,a_small_frac,clock,clrn,
						e,c_rm,c_is_inf_nan,c_inf_nan_frac,c_sign,
						c_exp,c_op_sub,c_large_frac,c_small_frac);
	
	wire [27:0] c_frac;
	fadd_cal calculation (c_op_sub,c_large_frac,c_small_frac,c_frac);
	
	wire [1:0] n_rm;
	wire n_is_inf_nan;
	wire [22:0] n_inf_nan_frac;
	wire n_sign;
	wire [7:0] n_exp;
	wire [27:0]n_frac;
	
	reg_cal_norm reg_cn(c_rm,c_is_inf_nan,c_inf_nan_frac,c_sign,c_exp,
						c_frac,clock,clrn,e,n_rm,n_is_inf_nan,n_inf_nan_frac,
						n_sign,n_exp,n_frac);
	
	fadd_norm normalization(n_rm,n_is_inf_nan,n_inf_nan_frac,n_sign,n_exp,n_frac,s);
	
	
	
endmodule
