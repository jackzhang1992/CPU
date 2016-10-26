`include "fmul_mul.v"
`include "reg_mul_add.v"
`include "fmul_add.v"
`include "reg_add_norm.v"
`include "fmul_norm.v"

module pipelined_fmul (a,b,rm,s,clock,clrn,e);
	input [31:0] a,b;
	input e;
	input [1:0] rm;
	input clock,clrn;
	output [31:0] s;
	wire m_sign;
	wire [9:0] m_exp10;
	wire m_is_inf_nan;
	wire [22:0] m_inf_nan_frac;
	wire [38:0] m_sum;
	wire [39:0] m_carry;
	wire[7:0] m_z8;
	fmul_mul mul1(a,b,m_sign,m_exp10,m_is_inf_nan,m_inf_nan_frac,m_sum,m_carry,m_z8);
	
	wire[1:0]a_rm;
	wire a_sign;
	wire [9:0] a_exp10;
	wire a_is_inf_nan;
	wire [22:0] a_inf_nan_frac;
	wire [38:0] a_sum;
	wire [39:0] a_carry;
	wire[7:0] a_z8;
	reg_mul_add reg_ma(rm,m_sign,m_exp10,m_is_inf_nan,
						m_inf_nan_frac,m_sum,m_carry,m_z8,clock,
						clrn,e,a_rm,a_sign,a_exp10,a_is_inf_nan,
						a_inf_nan_frac,a_sum,a_carry,a_z8);
	wire [47:8] a_z40;
	fmul_add mul2 (a_sum,a_carry,a_z40);
	wire [47:0] a_z48 = {a_z40,a_Z8};
	wire[1:0]n_rm;
	wire n_sign;
	wire [9:0] n_exp10;
	wire n_is_inf_nan;
	wire [22:0] n_inf_nan_frac;
	wire [47:0] n_z48;
	reg_add_norm reg_an(a_rm,a_sign,a_exp10,a_is_inf_nan,
						a_inf_nan_frac,a_z48,clock,clrn,e,
						n_rm,n_sign,n_exp10,n_is_inf_nan,
						n_inf_nan_frac,n_z48);
	fmul_norm mul3(n_rm,n_sign,n_exp10,n_is_inf_nan,
					n_inf_nan_frac,n_z48,s);

endmodule