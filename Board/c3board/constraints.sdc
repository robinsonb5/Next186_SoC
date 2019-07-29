## Generated SDC file "hello_led.out.sdc"

## Copyright (C) 1991-2011 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 11.1 Build 216 11/23/2011 Service Pack 1 SJ Web Edition"

## DATE    "Fri Jul 06 23:05:47 2012"

##
## DEVICE  "EP3C25Q240C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_50} -period 20.000 -waveform { 0.000 0.500 } [get_ports {clk_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks 

#**************************************************************
# Set Clock Latency
#**************************************************************


#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty;

#**************************************************************
# Set Input Delay
#**************************************************************

#**************************************************************
# Set Output Delay
#**************************************************************

**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {ps2k_clk ps2m_clk ps2k_dat ps2m_dat power_button reset_n rs232_rxd}] -to  *

set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]  -to  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[4]}]
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[4]}] -to [get_clocks {sys_inst|dcm_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}] -to [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}]  
set_false_path  -from  [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[0]}]  
set_false_path -from [get_clocks {clk50m}] -to [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}]
set_false_path -from [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[3]}] -to [get_clocks {clk50m}]
set_false_path -from [get_clocks {clk50m}] -to [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path -from [get_clocks {sys_inst|dcm_system|altpll_component|auto_generated|pll1|clk[1]}] -to [get_clocks {clk50m}]

set_false_path -from [get_registers {system:sys_inst|VGA_SC:sc|planarreq}]
set_false_path -from [get_registers {sys_inst|CPUUnit|cpu*}] -through [get_nets {sys_inst|CPUUnit|cpu|ALU16|HINIBBLE~0 sys_inst|CPUUnit|cpu|ALU16|HINIBBLE~1 sys_inst|CPUUnit|cpu|ALU16|HINIBBLE~2 sys_inst|CPUUnit|cpu|ALU16|LONIBBLE~0}] -to [get_cells {sys_inst|cache_ctl|cache_addr*}]

#**************************************************************
# Set Multicycle Path
#**************************************************************
set_multicycle_path -from [get_registers {sys_inst|CPUUnit|cpu*}] -setup -start 2
set_multicycle_path -from [get_registers {sys_inst|CPUUnit|cpu*}] -hold -start 1

#**************************************************************
# Set Maximum Delay
#**************************************************************


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

