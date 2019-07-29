#!/bin/bash

. Board/$BOARD/family

cat $1 | while read a; do
	b=${a,,}
	if [ "${b: -4}" = ".vhd" ]; then
		echo set_global_assignment -name VHDL_FILE ../../RTL/${a}
	fi
	if [ "${b: -4}" = ".qip" ]; then
		echo set_global_assignment -name QIP_FILE ../../Board/$FPGA_FAMILY/${a}
	fi
	if [ "${b: -2}" = ".v" ]; then
		echo set_global_assignment -name VERILOG_FILE ../../RTL/${a}
	fi
done

