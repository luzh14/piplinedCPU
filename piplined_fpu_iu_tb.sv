`timescale 1ns/1ps
`include "piplined_fpu_iu.v"
module piplined_fpu_iu_tb ();
reg clk,rst_n;


initial begin
	clk=0;
	rst_n=0;
end // initial

always #4 clk = ~clk;

piplined_fpu_iu dut(clk,clk,rst_n);

endmodule