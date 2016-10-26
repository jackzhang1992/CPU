module mux2x5(a0,a1,s,y);
	input[4:0] a0,a1;
	input  s;
	output [4:0]y;
	
	
	function [4:0] select;      
		input [4:0] a0,a1;
		input  s;
		case (s)
			2'b0:select =a0;
			2'b1:select =a1;	
		endcase
	endfunction
	
	assign y=select (a0,a1,s);

endmodule