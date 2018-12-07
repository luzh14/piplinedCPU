module dffe32 (d,clk,clrn,e,q); // a 32-bit register 
input [31:0] d; // input d 
input e; // e: enable 
input clk, clrn; // clock and reset 
output reg [31:0] q; // output q 
initial
	begin
		q <= 0;
	end
always @(negedge clrn or posedge clk) 
	if (clrn == 1) q <= 0; // q = 0 ifreset 
	else if (e) q <= d; // save d if enabled 
endmodule

