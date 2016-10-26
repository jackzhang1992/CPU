module core2_cache_tlb_memory(clock,memclock,resetn,v_pc1,pc1,inst1,ealu1,malu1,walu1,wn1,
				wd1,ww1,stall_lw1,stall_fp1,stall_lwc11,stall_swc11,stall1,
				mem_a,mem_data,mem_st_data,mem_access,mem_write,mem_ready);
			input clock,memclock,resetn;
			input [31:0] v_pc1,pc1,inst1,ealu1,malu1,walu1;
			output [31:0] wd1;
			output [4:0] wn1;
			output ww1,stall_lw1,stall_fp1,stall_lwc11,stall_swc11,stall1;
			output [31:0] mem_a;
			output [31:0]mem_data;
			output [31:0] mem_st_data;
			output [31:0] mem_access;
			output mem_write;
			output mem_ready;
			//core1
			wire [31:0] mem_a1;
			wire [31:0]mem_data1;
			wire [31:0] mem_st_data1;
			wire [31:0] mem_access1;
			wire mem_write1;
			cpu_cache_tlb core1(clock,memclock,resetn,v_pc1,pc1,inst1,ealu1,malu1,walu1,wn1,
				wd1,ww1,stall_lw1,stall_fp1,stall_lwc11,stall_swc11,stall1,
				mem_a1,mem_data1,mem_st_data1,mem_access1,mem_write1,mem_ready1);
				
			//core2
			wire [31:0] mem_a2;
			wire [31:0]mem_data2;
			wire [31:0] mem_st_data2;
			wire [31:0] mem_access2;
			wire mem_write2;
			cpu_cache_tlb core2(clock,memclock,resetn,v_pc2,pc2,inst2,ealu2,malu2,walu2,wn2,
				wd2,ww2,stall_lw2,stall_fp2,stall_lwc12,stall_swc12,stall2,
				mem_a2,mem_data2,mem_st_data2,mem_access2,mem_write2,mem_ready2);
			//mux
			reg cnt;
			always @(negedge resetn or posedge clock)begin
				if(resetn ==0)begin
					cnt<=0;
				end else if(mem_ready)begin
					cnt<=~cnt;
				end
			
			end
			
			wire select1 = ~cnt & mem_access1 | cnt & ~mem_access2;
			wire [31:0] mem_a = select1? mem_a1 : mem_a2;
			wire [31:0] mem_st_data = select1 ? mem_st_data1 : mem_st_data2;
			wire mem_access = select1 ? mem_access1 : mem_access2;
			wire mem_write = select1? mem_write1:mem_write2;
			
			//demux
			wire mem_ready1 = mem_ready & select1;
			wire mem_ready2 = mem_ready & ~select1;
			
			//main memory
			physical_memory mem(mem_a,mem_data,mem_st_data,mem_access,
								mem_write,mem_ready,clock,memclock,resetn);
				


endmodule