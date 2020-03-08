
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Next186_SoC(
		// CLOCK
	input clk50m,

// VGA	
	output [4:0]red,
	output [4:0]grn,
	output [4:0]blu,
	output hsync_n,
	output vsync_n,
	
// AUDIO	
	output sigma_l,
	output sigma_r,
	
// RS232
	input usart_rx,
	output usart_tx,
	input usart_rts,
	output usart_clk,
	
// IR
	input ir_data,
	
// SDRAM
	output ram_clk,
	output ram_cas,
	output ram_ras,
	output ram_we,		// ram_ncs is not present, so I assume it is always 0
	output ram_ldqm,
	output ram_udqm,
	output [1:0]ram_ba,
	output [12:0]ram_a,
	inout [15:0]ram_d,
	
// SPI
	output flash_ncs,		// active low
	output rtc_cs,			// active high
	output mmc_ncs,		// active low
	input mmc_ncd,	// low when card present
	input mmc_wp,  // high on write protect
	output spi_clk,
	input spi_miso,
	output spi_mosi,
	
// PS2
	output ps2iec_sel,
//	inout [3:0]ps2iec, // {kb_dat, kb_clk, mouse_clk, mouse_dat}
	input ps2_mouse_dat,
	input ps2_mouse_clk,
	input ps2_kb_dat,
	input ps2_kb_clk,	

// BUTTONS - normal 1, 0 when pushed
	input usart_cts,		// left
	input freeze_btn,		// middle
	input reset_btn,		// right

// SHIFTREG
	output ser_out_clk,
	output ser_out_dat,
	output ser_out_rclk
	
);

	wire clk_25;
	wire memclk;
	wire clk_cpu;
	wire clk_dsp;
	wire clk44100x256;
	wire clk14745600;
	wire pll1_locked;
	wire pll2_locked;
	wire r0, g0, b0;
	wire [2:0]led; // {mem_access, sd_access, halt};
 	wire ps2_kb_clk_nOE;
	wire ps2_kb_data_nOE;
	wire ps2_mouse_clk_nOE;
	wire ps2_mouse_data_nOE;

	
	assign ps2iec_sel = 1'b0;	// ps2 active
	assign flash_ncs = 1'b1;	// flash inactive
	assign rtc_cs = 1'b0;		// rtc inactive
	
//	dd_buf sdrclk_buf
//	(
//		.datain_h(1'b1),
//		.datain_l(1'b0),
//		.outclock(SDR_CLK),
//		.dataout(ram_clk)
//	);


	Clock_50to100Split mypll1
	(
		.inclk0(clk50m),
		.c0(clk_25),
		.c1(memclk),
		.c2(ram_clk),
		.locked(pll1_locked)
	);
		
	Clock_50to100Split_2ndRAM mypll2
	(
		.inclk0(clk50m),
		.c0(clk_cpu),
		.c1(clk_dsp),
		.locked(pll2_locked)
	);
		
	Clock_50toSlowClocks mypll3
	(
		.inclk0(clk50m),
		.c0(clk44100x256),
		.c1(clk14745600)
	);


	Next186SOCWrapper
	#(
	   .RowBits(13),
		.ColBits(9),
		.cpuclkfreq(625),
		.enableDSP(0)	 // The BlockRAM's better spent on debugging for now.
	) sys_inst
	(
		.CLK_50MHZ(clk50m),
		.clk_25(clk_25),
		.clk_sdr(memclk),
		.clk_cpu(clk_cpu),
		.clk_dsp(clk_dsp),
		.CLK44100x256(clk44100x256),
		.CLK14745600(clk14745600),
		.opl_reset(!freeze_btn),
		.VGA_R({red, r0}),
		.VGA_G({grn, g0}),
		.VGA_B({blu, b0}),
		.frame_on(),
		.VGA_HSYNC(hsync_n),
		.VGA_VSYNC(vsync_n),
//		.clk_25(clk_25),
//		.sdr_CLK_out(SDR_CLK),
		.sdr_n_CS_WE_RAS_CAS({ram_we, ram_ras, ram_cas}),
		.sdr_BA(ram_ba),
		.sdr_ADDR(ram_a),
		.sdr_DATA(ram_d),
		.sdr_DQM({ram_udqm, ram_ldqm}),
		.LED(led),
		.BTN_RESET(!reset_btn),
		.BTN_NMI(!freeze_btn),
		.RS232_DCE_RXD(1'b1),
		.RS232_DCE_TXD(),
		.RS232_EXT_RXD(1'b1),
		.RS232_EXT_TXD(),
		.SD_n_CS(mmc_ncs),
		.SD_DI(spi_mosi),
		.SD_CK(spi_clk),
		.SD_DO(spi_miso),
		.AUD_L(sigma_l),
		.AUD_R(sigma_r),

	 	.PS2_CLK1(ps2_kb_clk),
 	   .PS2_CLK1_nOE(ps2_kb_clk_nOE),
		.PS2_DATA1(ps2_kb_dat),
		.PS2_DATA1_nOE(ps2_kb_data_nOE),

		.PS2_CLK2(ps2_mouse_clk),
		.PS2_CLK2_nOE(ps2_mouse_clk_nOE),
		.PS2_DATA2(ps2_mouse_dat),
		.PS2_DATA2_nOE(ps2_mouse_data_nOE),

		.RS232_HOST_RXD(1'b1),
		.RS232_HOST_TXD(),
		.RS232_HOST_RST(),
		.GPIO(),
		.I2C_SCL(),
		.I2C_SDA(),
	);
	
	
	chameleon2_io_shiftreg shiftreg
	(
		.clk(clk_25),
		.ser_out_clk(ser_out_clk),
		.ser_out_dat(ser_out_dat),
		.ser_out_rclk(ser_out_rclk),	
	
		.reset_c64(1'b0),
		.reset_iec(1'b0),
		.ps2_mouse_clk(ps2_mouse_clk_nOE),
		.ps2_mouse_dat(ps2_mouse_data_nOE),
		.ps2_keyboard_clk(ps2_kb_clk_nOE),
		.ps2_keyboard_dat(ps2_kb_data_nOE),
		.led_green(led[1]),
		.led_red(led[0] | led[2])
	);
	
endmodule

