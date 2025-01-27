#************************************************************
# THIS IS A WIZARD-GENERATED FILE.                           
#
# Version 11.1 Build 216 11/23/2011 Service Pack 1 SJ Web Edition
#
#************************************************************

# Copyright (C) 1991-2011 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.



# Clock constraints

create_clock -name "clk8" -period 125.000ns [get_ports {clk8}] -waveform {0.000 62.500}


# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# create_generated_clock -name spi_clk -source [get_nets {inst|altpll_component|auto_generated|wire_pll1_clk[0]}] -divide_by 2 [get_nets {inst3|sck}]

#set slowclk mypll|altpll_component|auto_generated|pll1|clk[0]
#set memclk mypll|altpll_component|auto_generated|pll1|clk[1]
create_generated_clock -name sdram_clk_pin -source [get_pins {mypll|altpll_component|auto_generated|pll1|clk[2]}] [get_ports {sdram_clk}]

#set cpuclk mypll2|altpll_component|auto_generated|pll1|clk[0]
#create_generated_clock -name dspclk -source [get_pins {mypll2|altpll_component|auto_generated|pll1|clk[1]}]
create_generated_clock -name sysclk -source [get_pins {mypll2|altpll_component|auto_generated|pll1|clk[2]}]

#create_generated_clock -name aud1clk -source [get_pins {mypll3|altpll_component|auto_generated|pll1|clk[0]}]
#create_generated_clock -name aud2clk -source [get_pins {mypll3|altpll_component|auto_generated|pll1|clk[1]}]
#create_generated_clock -name aud3clk -source [get_pins {mypll2|altpll_component|auto_generated|pll1|clk[3]}]


#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty;

#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock sdram_clk_pin -max [expr 5.8] [get_ports *sd_data*]
set_input_delay -clock sdram_clk_pin -min [expr 3.2] [get_ports *sd_data*]

set_input_delay -clock sysclk -max 1.0 [get_ports mux_q*]
set_input_delay -clock sysclk -min 0.5 [get_ports mux_q*]
set_input_delay -clock sysclk -min 0.5 [get_ports spi_miso]
set_input_delay -clock sysclk -max 1.0 [get_ports spi_miso]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock sdram_clk_pin -max [expr 1.5 ] [get_ports *sd_*]
set_output_delay -clock sdram_clk_pin -min [expr -0.8 ] [get_ports *sd_*]

set_output_delay -clock sysclk -max 1.0 [get_ports mux*]
set_output_delay -clock sysclk -min 0.5 [get_ports mux*]

# Multicycles

set_multicycle_path -from [get_clocks {sdram_clk_pin}] -to [get_clocks {mypll|altpll_component|auto_generated|pll1|clk[1]}] -setup -end 2
set_multicycle_path -from [get_clocks {sdram_clk_pin}] -to [get_clocks {mypll|altpll_component|auto_generated|pll1|clk[1]}] -setup -end 2

#set_multicycle_path -from {sd_data[*]} -to {TG68Test:mytg68test|sdram:mysdram|vga_data[*]} -setup -end 2
#set_multicycle_path -from {sd_data[*]} -to {TG68Test:mytg68test|sdram:mysdram|sdata_reg[*]} -setup -end 2

set_multicycle_path -through *zpu*Mult0* -setup -end 2
set_multicycle_path -through *zpu*Mult0* -hold -end 2


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from {freeze_n} -to {*}
set_false_path -from {phi2_n*} -to {*}
set_false_path -to {red*} -from {*}
set_false_path -to {grn*} -from {*}
set_false_path -to {blu*} -from {*}
set_false_path -to {nHSync} -from {*}
set_false_path -to {nVSync} -from {*}
set_false_path -to {sdram_clk} -from {*}
set_false_path -to {sigma*} -from {*}

set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to mypll|altpll_component|auto_generated|pll1|clk[1]
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to mypll2|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to dspclk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to sysclk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to aud1clk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to aud2clk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[0] -to mypll2|altpll_component|auto_generated|pll1|clk[3]

set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to mypll|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to mypll2|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to dspclk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to sysclk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to aud1clk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to aud2clk
set_false_path -from mypll|altpll_component|auto_generated|pll1|clk[1] -to mypll2|altpll_component|auto_generated|pll1|clk[3]

set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to mypll|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to mypll|altpll_component|auto_generated|pll1|clk[1]
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to dspclk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to sysclk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to aud1clk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to aud2clk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[0] -to mypll2|altpll_component|auto_generated|pll1|clk[3]

set_false_path -from aud1clk -to mypll|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from aud1clk -to mypll|altpll_component|auto_generated|pll1|clk[1]
set_false_path -from aud1clk -to mypll2|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from aud1clk -to dspclk
set_false_path -from aud1clk -to sysclk
set_false_path -from aud1clk -to aud2clk
set_false_path -from aud1clk -to mypll2|altpll_component|auto_generated|pll1|clk[3]

set_false_path -from aud2clk -to mypll|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from aud2clk -to mypll|altpll_component|auto_generated|pll1|clk[1]
set_false_path -from aud2clk -to mypll2|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from aud2clk -to dspclk
set_false_path -from aud2clk -to sysclk
set_false_path -from aud2clk -to aud1clk
set_false_path -from aud2clk -to mypll2|altpll_component|auto_generated|pll1|clk[3]

set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to mypll|altpll_component|auto_generated|pll1|clk[0]
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to memclk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to cpuclk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to dspclk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to sysclk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to aud1clk
set_false_path -from mypll2|altpll_component|auto_generated|pll1|clk[3] -to aud2clk
