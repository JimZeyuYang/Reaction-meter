module fsm (clk, slow_clk, trigger, stop_counter, en_counter, reset_counter, time_out, en_lfsr, start_delay, ledr);
	
	input clk, slow_clk, trigger, time_out, stop_counter;
	output reg en_lfsr, start_delay, en_counter, reset_counter;
	output reg [9:0] ledr;
	
	reg [1:0] state;
	reg [3:0] count;
	initial count = 4'b0000;
	parameter IDLE = 2'b00, LED = 2'b01, DELAY = 2'b10, COUNT = 2'b11;
	
	initial state = IDLE;
	
	always @ (posedge clk)
		case (state)
			IDLE: if(trigger==1'b1)
						begin
						state <= LED;
						ledr <= 10'b0;
						end
						
			LED:  begin
					if(slow_clk==1'b1)
						begin
						case (count)
							4'b0000: ledr <= 10'b0000000001;
							4'b0001: ledr <= 10'b0000000011;
							4'b0010: ledr <= 10'b0000000111;
							4'b0011: ledr <= 10'b0000001111;
							4'b0100: ledr <= 10'b0000011111;
							4'b0101: ledr <= 10'b0000111111;
							4'b0110: ledr <= 10'b0001111111;
							4'b0111: ledr <= 10'b0011111111;
							4'b1000: ledr <= 10'b0111111111;
							4'b1001: ledr <= 10'b1111111111;
						default: ;
						endcase
						count <= count + 1'b1;
						end
					if(count==4'b1010)
						begin
						state <= DELAY;
						count <= 4'b0000;
						end
					end
						
			DELAY: if(time_out==1'b1)
						begin
						state <= COUNT;
						ledr <= 10'b0;
						end
			
			COUNT: if(stop_counter==1'b1)
						state <= IDLE;
			
			default: ;
			endcase
						
	
	always @ (*)
		case (state)
			IDLE: begin
						en_lfsr <= 1'b0;
						start_delay <= 1'b0;
						en_counter <= 1'b0;
					end
					
			LED:  begin
						reset_counter <= 1'b1;
						en_lfsr <= 1'b1;
						start_delay <= 1'b0;
						if(count==4'b1010)
							en_lfsr <= 1'b0;
					end
						
			DELAY: begin
						reset_counter <= 1'b0;
						en_lfsr <= 1'b0;
						start_delay <= 1'b1;
					 end
					 
			COUNT: en_counter <= 1'b1;			
			
		default: ;
		endcase
		
endmodule


