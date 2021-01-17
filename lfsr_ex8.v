module lfsr_ex8 (clk, en, prbs);
	
	input clk;
	input en;
	output [13:0] prbs;
	
	reg [13:0] sreg;
	
	initial sreg = 14'b1;
	
	always @ (posedge clk)
		if (en==1'b1)
		sreg <= {8'b0, sreg[4:0], sreg[5] ^ sreg[0]};
		
	assign prbs = {sreg[5:0], 8'b0} - {6'b0, sreg[5:0], 2'b0} - {7'b0, sreg[5:0], 1'b0};
	
endmodule
