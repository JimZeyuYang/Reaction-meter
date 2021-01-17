module ex9_top (CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, LEDR[9:0]);

	input CLOCK_50;
	input [3:0] KEY;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
	output [9:0] LEDR;
	
	wire tick_ms;
	wire tick_hs;
	wire en_lfsr;
	wire start_delay;
	wire time_out;
	wire [13:0] prbs;
	
	wire [3:0] BCD0;
	wire [3:0] BCD1;
	wire [3:0] BCD2;
	wire [3:0] BCD3;
	wire [3:0] BCD4;
	
	wire en_counter;
	wire reset_counter;
	wire [15:0] count;
	
	clktick ck (CLOCK_50, 16'd49999, tick_ms);
	clktick ck2 (tick_ms, 16'd499, tick_hs);
	
	fsm banana (tick_ms, tick_hs, ~KEY[3], ~KEY[0], en_counter, reset_counter, time_out, en_lfsr, start_delay, LEDR[9:0]);
	
	lfsr_ex8 apple (tick_ms, en_lfsr, prbs);
	
	delay orange (tick_ms, start_delay, prbs, time_out);
	
	counter_16 watermelon (tick_ms, en_counter, reset_counter, count[15:0]);
	
	bin2bcd_16 grapes(count, BCD0, BCD1, BCD2, BCD3, BCD4);
	
	four_bit_hex_to_7seg seg0 (HEX0, BCD0);
	four_bit_hex_to_7seg seg1 (HEX1, BCD1);
	four_bit_hex_to_7seg seg2 (HEX2, BCD2);
	four_bit_hex_to_7seg seg3 (HEX3, BCD3);
	four_bit_hex_to_7seg seg4 (HEX4, BCD4);
	
endmodule

