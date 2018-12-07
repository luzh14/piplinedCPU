module cla32(a, b, ci, s);
	input [31:0] a, b;
	input ci;
	output [31:0] s;

	assign s=a+b;

endmodule