module dffe32(d,clk,ckrn,e,q);
	input [31:0]d;
	input clk,clrn,e;
	output [31:0] q;
	reg [31:0] q;
	always @(negedge clrn or posedge clk)begin
	
		if (clrn == 0) begin
			q<= 0;
		end
		else begin
			if(e) q<=d; 
		end
	
	end
		
endmodule