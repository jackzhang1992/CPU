module regfile2w (rna,rnb,dx,wnx,wex,dy,wny,wey,clk,clrn,qa,qb);
input [4:0] rna,rnb,wnx,wny;
input [31:0] dx,dy;
input wex,wey,clk,clrn;
output [31:0] qa,qb;
reg [31:0] register[0:31];
assign qa = register[rna];
assign qb = register[rnb];
always @(posedge clk or negedge clrn)begin
	if(clrn==0)begin
		integer i;
		for (i=0;i<32;i=i+1) register[i]<=0;
		
	end else begin
		if(wey)
			register[wny]<=dy;
		if(wex&&(!wey||(wnx!=wny)))
			register[wnx] =dx; 
	end

end	

endmodule