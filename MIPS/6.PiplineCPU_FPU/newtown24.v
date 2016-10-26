`include "wallace_tree24x26_mul.v"
`include "wallace_tree26x24.v"
`include "wallace_tree26x26.v"

module newtown24 (a,b,fdiv,enable,clock,resetn,
								q,busy,count,reg_x,stall);
		input [23:0]a;
		input [23:0]b;
		input fdiv;
		input enable,clock,resetn;
		output [31:0] q;
		output busy;
		output [4:0]count;
		output [25:0] reg_x;
		output stall;
		
		reg  [31:0] q;
		reg  busy;
		reg  [4:0]count;
		reg  [25:0] reg_x;
		reg  stall;
		reg busy;
		
		wire [7:0] x0 = rom(b[22:19]);
		always @(posedge clock or negedge resetn)begin
			if(resetn ==0)begin
				count <= 5'b0;
				busy  <= 1'b0;
			end else begin
				if (fdiv &(count == 0)) begin
					count <=5'b1;
					busy <= 1'b1;
				end else begin
					if(count == 5'h1) begin
						reg_x <= {2'b1,x0,16'b0};
						reg_a <= a;
						reg_b <= b;
					end
					if (count !=0) count <= count +5'b1;
					if (count == 5'h0f) busy <=5'h0;
					if (count == 5'h10) count <=5'b0;
					if ((count == 5'h06)||
						(count == 5'h0b) ||
						(count == 5'h10))
						reg_x <= x52[50:25];
				end
			end
		end
		
		assign stall = fdiv & (count ==0) | busy;
		wire [49:0] bxi;
		wire [51:0] x52;
		wallace_tree26x24 bxxi(reg_x,reg_b,bxi);
		wire [25:0] b26 = ~bxi[48:23] +1'b1;
		wallace_tree26x26 xip1(reg_xn,b26,x52);
		wire  [48:0] m_s;
		wire [41:0] m_c;
		wallace_tree24x26_mul wt (reg_a,reg_x,m_s[48:8],m_c,m_s[7:0]);
		reg [48:0] a_s;
		reg [41:0] a_c;
		always @(negedge resetn or posedge clock)begin
			if(resetn==0)begin
				a_s <=0;
				a_c<=0;
				q<=0;
			end else if(enable) begin
				a_s <=m_s;
				a_c<=m_c;
				q<=e2p;
			
			end
		end
		
		wire [49:0] d_x = {1'b0,a_s} + {a_c,8'b0};
		wire [31:0] e2p = {d_x[48:18],|d_x[17:0]};
		
		function [7:0] rom;
			input [3:0] b;
			case (b)
				4'h0:rom = 8'hf0;  4'h1:rom = 8'hd4;
				4'h2:rom = 8'hba;  4'h3:rom = 8'ha4;
				4'h4:rom = 8'h8f;  4'h5:rom = 8'h7d;
				4'h6:rom = 8'h6c;  4'h7:rom = 8'h5c;
				4'h8:rom = 8'h4e;  4'h9:rom = 8'h41;
				4'ha:rom = 8'h35;  4'hb:rom = 8'h29;
				4'hc:rom = 8'h1f;  4'hd:rom = 8'h15;
				4'he:rom = 8'h0c;  4'hf:rom = 8'h04;
			endcase
		endfunction
		
endmodule