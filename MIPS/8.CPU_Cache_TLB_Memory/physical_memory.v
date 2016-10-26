module physical_memory #(parameter A_WIDTH = 32)
	(a,dout,din,strobe,rw,ready,clk,memclk,clrn);
	input [A_WIDTH-1:0] a;
	output [31:0] dout;
	input [31:0] din;
	input strobe;
	input rw;
	output ready;
	input clk,memclk,clrn;
	
	reg	[2:0] wait_counter;
	reg ready;
	always @(negedge clrn or posedge clk)begin
		if(clrn ==0 )begin
			wait_counter<=3'd0;
		
		end else begin
			if(strobe)begin
				if(wait_counter == 3'h5)begin
					ready<=1'b1;
					wait_counter<= 3'b0;
				end else begin
					ready<= 1'b0;
					wait_counter <= wait_counter +3'b1;
				end
			end else begin
				ready <= 1'b0;
				wait_counter <= 3'b0;
			
			end
		
		end
	
	end
	
wire [31:0] m_out32 = a[13]? mem_data_out3 : mem_data_out2;
wire [31:0] m_out10 = a[28]? mem_data_out1 : mem_data_out0;
wire [31:0] mem_out = a[29]? m_out32 : m_out10;
assign dout = ready ? mem_out : 32'hzzzz_zzzz;


//(0)
wire [31:0] mem_data_out0;
wire write_enable0 = ~a[29] & ~a[28] &rw ~clk;

lpm_ram_dq ram0(.data(din),.address(a[8:2]),
					.we(write_enable0),.inclk(memclk),
					.outclock(memclk & strobe),.q(mem_data_out0));
	defparam ram.lpm_width = 32;
			 ram.lpm_widthad = 7;
			 ram.lpm_indata = "registered";
			 ram.lpm_outdata = "registered";
			 ram.lpm_file = "cpu_cache_tlb_0.mif";
			 ram.lpm_address_control = "registered";
			 
//(1)
wire [31:0] mem_data_out1;
wire write_enable1 = ~a[29] & a[28] &rw ~clk;

lpm_ram_dq ram1(.data(din),.address(a[8:2]),
					.we(write_enable1),.inclk(memclk),
					.outclock(memclk & strobe),.q(mem_data_out1));
	defparam ram.lpm_width = 32;
			 ram.lpm_widthad = 7;
			 ram.lpm_indata = "registered";
			 ram.lpm_outdata = "registered";
			 ram.lpm_file = "cpu_cache_tlb_1.mif";
			 ram.lpm_address_control = "registered";			 

//(2)
wire [31:0] mem_data_out2;
wire write_enable2 = a[29] & ~a[13] &rw ~clk;

lpm_ram_dq ram2(.data(din),.address(a[8:2]),
					.we(write_enable2),.inclk(memclk),
					.outclock(memclk & strobe),.q(mem_data_out2));
	defparam ram.lpm_width = 32;
			 ram.lpm_widthad = 7;
			 ram.lpm_indata = "registered";
			 ram.lpm_outdata = "registered";
			 ram.lpm_file = "cpu_cache_tlb_2.mif";
			 ram.lpm_address_control = "registered";

//(3)
wire [31:0] mem_data_out3;
wire write_enable3 =  a[29] &  a[13] &rw ~clk;

lpm_ram_dq ram3(.data(din),.address(a[8:2]),
					.we(write_enable3),.inclk(memclk),
					.outclock(memclk & strobe),.q(mem_data_out3));
	defparam ram.lpm_width = 32;
			 ram.lpm_widthad = 7;
			 ram.lpm_indata = "registered";
			 ram.lpm_outdata = "registered";
			 ram.lpm_file = "cpu_cache_tlb_3.mif";
			 ram.lpm_address_control = "registered";	

endmodule
			 