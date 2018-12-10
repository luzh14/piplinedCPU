module instmem (a,inst);
	input [31:0]a;
	output [31:0]inst;
	reg [31:0] rom[0:31];

parameter MEM_INIT="float_add.txt";

initial begin
	$readmemh(MEM_INIT, rom);
end

assign inst = rom[a[6:2]];

endmodule