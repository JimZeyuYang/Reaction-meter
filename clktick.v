module clktick (clkin, N, tick);


input clkin;
input [15:0] N;
output tick;

reg [15:0] count;
reg tick;

initial tick = 1'b0;

	always @ (posedge clkin)
			if (count == 0) 
			begin
				tick <= 1'b1;
				count <= N;
				end
			else begin
				tick <= 1'b0;
				count <= count - 1'b1;
			end
endmodule
