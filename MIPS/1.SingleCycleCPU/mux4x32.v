module mux4x32(a0,a1,a2,a3,s,y);
	input [31:0]a0,a1,a2,a3;
	input [1:0]s;
	output [31:0]y;
	assign y=select(a0,a1,a2,a3,s);
	
	
	function [31:0]select;
	input [31:0] a0,a1,a2,a3;
	input [1:0] s;
	case(s)
		2'd0:select=a0;
		2'd1:select=a1;
		2'd2:select=a2;
		2'd3:select=a3;
	endcase
	endfunction
	
endmodule
