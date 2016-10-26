#include "sccpu_dataflow.v"
#include "scinstmem.v"
#include "scdatamem.v"

module sccomp_dataflow(
	clock,
	resetn,
	inst,
	pc,
	aluout,
	memout,
	mem_clk
);

input clock,resetn,mem_clk;
output [31:0] inst,pc,aluout,memout;

wire [31:0] data;
wire wmem;

sccpu_dataflow s(
				clock,
				resetn,
				inst,
				memout,
				pc,
				wmem,
				aluout,
				data);

scinstmem imem (
				pc,
				inst);

scdatamem dmem (
				clock,
				memout,
				data,
				aluout,
				wmem,
				mem_clk,
				mem_clk);



endmodulel