module inst_mem (
				a,
				inst
				);
input [31:0] a;
output [31:0] inst;

lpm_rom lpm_rom_component (
							.address (a[7:2]),
							.q(inst)
							)
defparam lpm_rom_component.lpm_width = 32;
		 lpm_rom_component.lpm_widthad = 5;
		 lpm_rom_component.lpm_numwords = "unused";
		 lpm_rom_component.lpm_file = "inst_mem.mif";
		 lpm_rom_component.lpm_indata = "unused";
		 lpm_rom_component.lpm_outdata = "unregistered";
		 lpm_rom_component.lpm_address_control = "unregistered";
			
endmodule