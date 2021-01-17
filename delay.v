module delay (clk, trigger, N, time_out);
	
	input clk, trigger;
	input [13:0] N;
	output time_out;
	
	reg [13:0] count;
	reg time_out;
	
	reg [1:0] state;
	parameter IDLE = 2'b00, 	 COUNTING = 2'b01;
	parameter TIME_OUT = 2'b10, WAIT_LOW = 2'b11;
	
	initial state = IDLE;
	
	always @ (posedge clk) 
		case (state)
			IDLE: if (trigger==1'b1)
						state <= COUNTING;
				  else
						count <= N - 1'b1;
			COUNTING: if (count==0)
							begin
							count = N - 1'b1;
							state <=	TIME_OUT;
							end
						 else
							count <= count - 1'b1;
			TIME_OUT: if (trigger==1'b0)
							state <= IDLE;
						 else
							state <= WAIT_LOW;
			WAIT_LOW: if (trigger==1'b0)
							state <= IDLE;
			default: ;
		 endcase
		 
	always @ (*)
		case (state)
			IDLE:			time_out = 1'b0;
			COUNTING:	time_out = 1'b0;
			TIME_OUT:	time_out = 1'b1;
			WAIT_LOW:	time_out = 1'b0;
			default: ;
		endcase
		
endmodule


