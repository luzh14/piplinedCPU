module MIPS_CP1_08 (
 input  clk, rst,  
 output y 	
);
wire [31:0]mmo;
piplined_fpu_iu dut(clk,clk,rst,mmo);
assign y = ^mmo; 
endmodule
