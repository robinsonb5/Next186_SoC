create_clock -name {MAX10_CLK1_50} -period 20.000 -waveform {0.000 10.000} { MAX10_CLK1_50 }

derive_pll_clocks -create_base_clocks

create_generated_clock -name clk25 -source [get_pins {mypll|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name sdram_clock -source [get_pins {mypll|altpll_component|auto_generated|pll1|clk[2]}] 
create_generated_clock -name sysclk -source [get_pins {mypll|altpll_component|auto_generated|pll1|clk[1]}]
create_generated_clock -name cpuclk -source [get_pins {mypll2|altpll_component|auto_generated|pll1|clk[0]}]
create_generated_clock -name dspclk -source [get_pins {mypll2|altpll_component|auto_generated|pll1|clk[1]}]
create_generated_clock -name aud1clk -source [get_pins {mypll3|altpll_component|auto_generated|pll1|clk[0]}]
create_generated_clock -name aud2clk -source [get_pins {mypll3|altpll_component|auto_generated|pll1|clk[1]}]

set_input_delay -clock { sdram_clock } -min 3.5 [get_ports *DRAM_DQ*]
set_input_delay -clock { sdram_clock } -max 6.5 [get_ports *DRAM_DQ*]

set_output_delay -clock { sdram_clock } -min -0.5 [get_ports DRAM_*]
set_output_delay -clock { sdram_clock } -max -1.5 [get_ports DRAM_*]

set_multicycle_path -from [get_clocks {sdram_clock}] -to [get_clocks {mypll|altpll_component|auto_generated|pll1|clk[1]}] -setup 2
# set_multicycle_path -from [get_clocks {sdram_clock}] -to [get_clocks {mypll|altpll_component|auto_generated|pll1|clk[1]}] -hold 2

# Multicycles for multiplier - is this valid?
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_sgn} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -setup -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d1[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -setup -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d2[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -setup -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_sgn} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -hold -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d1[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -hold -end 2
set_multicycle_path -from {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|alu_d2[*]} -to {VirtualToplevel:virtualtoplevel|eightthirtytwo_cpu:cpu|eightthirtytwo_alu:alu|mulresult[*]} -hold -end 2


set_multicycle_path -from [get_registers {*|sys_inst|CPUUnit|cpu*}] -setup -start 2
set_multicycle_path -from [get_registers {*|sys_inst|CPUUnit|cpu*}] -hold -start 1


set_false_path -from [get_clocks {mypll2|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {mypll|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path -from [get_clocks {mypll2|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {mypll|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path -from [get_clocks {mypll2|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {mypll3|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path -from [get_clocks {mypll3|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {mypll2|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path -from [get_clocks {mypll3|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {mypll2|altpll_component|auto_generated|pll1|clk[0]}]

set_false_path -from [get_clocks {mypll|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {mypll2|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path -from [get_clocks {MAX10_CLK1_50}] -to [get_clocks {mypll2|altpll_component|auto_generated|pll1|clk[0]}]

set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to mypll|altpll_component|auto_generated|pll1|clk[1]
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to mypll2|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to [get_clocks dspclk]
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to sysclk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to aud1clk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to aud2clk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to mypll2|altpll_component|auto_generated|pll1|clk[3]

#set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to mypll|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to mypll2|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to dspclk
#set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to sysclk
#set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to aud1clk
#set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to aud2clk
#set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to mypll2|altpll_component|auto_generated|pll1|clk[3]

#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to mypll|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to mypll|altpll_component|auto_generated|pll1|clk[1]
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to dspclk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to sysclk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to aud1clk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to aud2clk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to mypll2|altpll_component|auto_generated|pll1|clk[3]

#set_false_path -from aud1clk -to mypll|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from aud1clk -to mypll|altpll_component|auto_generated|pll1|clk[1]
#set_false_path -from aud1clk -to mypll2|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from aud1clk -to dspclk
#set_false_path -from aud1clk -to sysclk
#set_false_path -from aud1clk -to aud2clk
#set_false_path -from aud1clk -to mypll2|altpll_component|auto_generated|pll1|clk[3]

#set_false_path -from aud2clk -to mypll|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from aud2clk -to mypll|altpll_component|auto_generated|pll1|clk[1]
#set_false_path -from aud2clk -to mypll2|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from aud2clk -to dspclk
#set_false_path -from aud2clk -to sysclk
#set_false_path -from aud2clk -to aud1clk
#set_false_path -from aud2clk -to mypll2|altpll_component|auto_generated|pll1|clk[3]

#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to mypll|altpll_component|auto_generated|pll1|clk[0]
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to memclk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to cpuclk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to dspclk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to sysclk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to aud1clk
#set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to aud2clk
