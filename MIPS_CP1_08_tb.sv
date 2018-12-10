`timescale 1ns/1ps
`include "MIPS_CP1_08.v"
module MIPS_CP1_08_tb ();
reg clk,rst_n;
wire y;

initial begin
	clk=0;
	rst_n=0;
end // initial

always #4 clk = ~clk;

MIPS_CP1_08 dut(clk,rst_n,y);

endmodule