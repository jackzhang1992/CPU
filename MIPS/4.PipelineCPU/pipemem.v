module pipemem (we,addr,datain,clk,inclk,outclk,dataout);
	input [31:0] addr,datain;
	input clk,we,inclk,outclk;
	output [31:0] dataout;
	
	wire write_enable = we& ~clk;
	lpm_ram_dq ram(.data(datain),.address(addr[6:2]),
				.we(write_enable),.inclock(inclk),
				.outclock(outclk),.q(dataout));
	defparam ram.lpm_width = 32,
			 ram.lpm_witdhad = 5,
			 ram.lpm_indata = "resgistered",
			 ram.lpm_outdata = "resgistered",
			 ram.lpm_file = "pipedmem.mif",
			 ram.lpm_address_control = "resgistered";
			 

endmodule