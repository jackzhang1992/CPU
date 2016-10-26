module mcmem(clk,dataout,datain,addr,we,inclk,outclk);
	input [31:0] datain;
	input [31:0] addr;
	input clk,we,inclk,outclk;
	output [31:0] dataout;
	
	wire write_enable = we & ~clk;
	lpm_ram_dq ram(.data(datain),.address(addr[7:2]),
					.we(write_enable),.inclk(inclk),
					.outclock(outclk),.q(dataout));
	defparam ram.lpm_width = 32;
			 ram.lpm_widthad = 6;
			 ram.lpm_indata = "registered";
			 ram.lpm_outdata = "registered";
			 ram.lpm_file = "mcmem.mif";
			 ram.lpm_address_control = "registered";


endmodule