`include "cpu_cache_tlb.v"
`include "physical_memory.v"

module cpu_cache_tlb_memory(
	clock,memclock,resetn,v_pc,pc,inst,ealu,malu,walu,wn,wd,ww,
	stall_lw,stall_fp,stall_lwc1,stall_swc1,stall,
	mem_a,mem_data,mem_st_data,mem_access,mem_write,mem_ready
);
	input clock,memclock,resetn;
	output [31:0]v_pc,oc,inst,ealu,malu,walu;
	output [31:0]wd;
	output [4:0] wn;
	output ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall;
	output [31:0]mem_a;
	output [31:0]mem_data;
	output [31:0]mem_st_data;
	output mem_access;
	output mem_write;
	output mem_ready;
	//cpu
	cpu_cache_tlb cpucachetlb(
		clock,memclock,resetn,v_pc,pc,inst,ealu,malu,walu,wn,wd,ww,
	stall_lw,stall_fp,stall_lwc1,stall_swc1,stall,
	mem_a,mem_data,mem_st_data,mem_access,mem_write,mem_ready
);

	
	//main memory
	physical_memory mem(mem_a,mem_data,mem_st_data,mem_access,
				mem_write,mem_ready,clock,memclock,resetn);
		

endmodule