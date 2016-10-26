`include "wallace_tree24x26_mul.v"
`include "wallace_tree24x28.v"
`include "wallace_tree26x26.v"

module  root_newton24 (d,fsqrt,enable,clock,resetn,
								q,busy,count,reg_x,stall);
		input [23:0]d;
		input fsqrt;
		input enable,clock,resetn;
		output [31:0] q;
		input [23:0];
		output busy;
		output stall;
		output [4:0]count;
		output [25:0] reg_x;
		
	
		reg  [31:0] q;
		reg [23:0] reg_d;
		reg  [25:0] reg_x;
		reg  [4:0]count;
		reg  busy;
		
		
		wire [7:0] x0 = rom(d[23:19]);
		always @(posedge clock or negedge resetn)begin
			if(resetn ==0)begin
				count <= 5'b0;
				busy  <= 1'b0;
			end else begin
				if (fsqrt &(count == 0)) begin
					count <=5'b1;
					busy <= 1'b1;
				end else begin
					if(count == 5'h1) begin
						reg_x <= {2'b1,x0,16'b0};
						reg_d <= d;
					end
					if (count !=0) count <= count +5'b1;
					if (count == 5'h15) busy <=5'h0;
					if (count == 5'h16) count <=5'b0;
					if ((count == 5'h08)||
						(count == 5'h0f) ||
						(count == 5'h16))
						reg_x <= x52[50:25];
				end
			end
		end
		
		assign stall = fsqrt & (count ==0) | busy;
		wire [51:0] x_2;
		wire [51:0] x2d;
		wire [51:0] x52;
		wallace_tree26x26  x2(reg_x,reg_x,x2);
		wallace_tree24x28  xd (reg_d,x_2[52:25],x2d);
		wire [25:0] b26 = 26'h3000000 - x2d[49:24];
		
		wallace_tree26x26 xip1(reg_x,b26,x52);
		
		wire  [48:0] m_s;
		wire [41:0] m_c;
		wallace_tree24x26_mul wt (reg_d,reg_x,m_s[48:8],m_c,m_s[7:0]);
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
		wire [31:0] e2p = {d_x[47:17],|d_x[16:0]};
		
		function [7:0] rom;
			input [4:0] d;
			case (d)
				5'h08:rom = 8'hf0;  5'h09:rom = 8'hd5;
				5'ha0:rom = 8'hbe;  5'h0b:rom = 8'hab;
				5'h0c:rom = 8'h99;  5'h0d:rom = 8'h8a;
				5'h0e:rom = 8'h7c;  5'h0f:rom = 8'h6f;
				5'h10:rom = 8'h64;  5'h11:rom = 8'h5a;
				5'h12:rom = 8'h50;  5'h13:rom = 8'h47;
				5'h14:rom = 8'h3f;  5'h15:rom = 8'h38;
				5'h16:rom = 8'h31;  5'h17:rom = 8'h2a;
				5'h18:rom = 8'h24;  5'h19:rom = 8'h1e;
				5'h1a:rom = 8'h19;  5'h1b:rom = 8'h14;
				5'h1c:rom = 8'h0f;  5'h1d:rom = 8'h0a;
				5'h1e:rom = 8'h06;  5'h1f:rom = 8'h02;
				default:  rom = 8'hff;
			endcase
		endfunction
		
		
endmodule