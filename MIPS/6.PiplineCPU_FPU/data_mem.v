module data_mem(we,
				addr,
				datain,
				clk,
				inclk,
				outclk,
				dataout);
	input [31:0] datain;
	input [31:0] addr;
	input clk,we,inclk,outclk;
	output [31:0] dataout;
	wire 		write_enable = we & ~clk;
	lpm_ram_dq ram (
					.data(datain),
					.address((addr[6:2])),
					.we (write_enable),
					.inclock(inclk),
					.outclock(outclk),
					.q(dataout)
					);
	defparam ram.lpm_width = 32;
			 ram.lpm_widthad = 5;
			 ram.lpm_indata = "registered";
			 ram.lpm_outdata = "registered";
			 ram.lpm_file = "data_mem.mif";
			 ram.lpm_address_control = "registered";
			 
			 
endmodule

