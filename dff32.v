module dff32(d, clk, clrn, q);
	input d, clk, clrn;
	output q;
	wire [31:0] d;
	reg [31:0] q;
	initial
	begin
		q <= 0;
	end
	always @ (posedge clk or posedge clrn) begin
		if (clrn == 1) q <= 0;
		else q <= d;
	end
endmodule
