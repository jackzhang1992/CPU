onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /openmips_min_sopc_tb/openmips_min_sopc0/clk
add wave -noupdate -label rst /openmips_min_sopc_tb/openmips_min_sopc0/rst
add wave -noupdate -label rom_ce_o /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rom_ce_o
add wave -noupdate -label if_id0/if_inst -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/if_inst
add wave -noupdate -label if_id0/id_pc -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/id_pc
add wave -noupdate -label if_id0/id_inst -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/id_inst
add wave -noupdate -format Literal -label id0/wreg_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/wreg_o
add wave -noupdate -label id0/wd_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/wd_o
add wave -noupdate -label id0/reg1_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg1_o
add wave -noupdate -label id0/reg2_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg2_o
add wave -noupdate -label id0/alusel_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/alusel_o
add wave -noupdate -label id0/aluop_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/aluop_o
add wave -noupdate -format Literal -label ex0/wreg_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wreg_o
add wave -noupdate -label ex0/wd_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wd_o
add wave -noupdate -label ex0/wdata_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wdata_o
add wave -noupdate -format Literal -label mem0/wreg_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wreg_o
add wave -noupdate -label mem0/wd_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wd_o
add wave -noupdate -label mem0/wdata_o -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wdata_o
add wave -noupdate -format Literal -label mem_wb0/wb_wreg -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wreg
add wave -noupdate -label mem_wb0/wb_wd -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wd
add wave -noupdate -label mem_wb0/wb_wdata -radix hexadecimal /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wdata
add wave -noupdate -label {regfile1/regs[1]} -radix hexadecimal {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[1]}
add wave -noupdate -label regs -childformat {{{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[0]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[1]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[2]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[3]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[4]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[5]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[6]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[7]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[8]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[9]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[10]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[11]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[12]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[13]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[14]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[15]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[16]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[17]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[18]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[19]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[20]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[21]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[22]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[23]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[24]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[25]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[26]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[27]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[28]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[29]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[30]} -radix hexadecimal} {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[31]} -radix hexadecimal}} -expand -subitemconfig {{/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[0]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[1]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[2]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[3]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[4]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[5]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[6]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[7]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[8]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[9]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[10]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[11]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[12]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[13]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[14]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[15]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[16]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[17]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[18]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[19]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[20]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[21]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[22]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[23]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[24]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[25]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[26]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[27]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[28]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[29]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[30]} {-height 15 -radix hexadecimal} {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[31]} {-height 15 -radix hexadecimal}} /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs
add wave -noupdate -radix hexadecimal {/openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile1/regs[1]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {224405 ps} 0}
configure wave -namecolwidth 145
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {182285 ps} {408005 ps}
