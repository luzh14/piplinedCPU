module alu(a, b, aluc, r, z);
	input [31:0] a, b;
	input [2:0] aluc;
	output [31:0] r; // output: alu result // 0 0 0 ADD 
	output z; // output: zero flag // x 1 0 0 SUB 
	wire [31:0] d_and = a & b; // 0 0 1 AND 
	wire [31:0] d_or = a | b; // 1 0 1 OR 
	wire [31:0] d_xor = a ^ b; // 0 1 0 XOR 
	wire [31:0] d_and_or = aluc[2]? d_or : d_and; // 0 1 1 SLL 
	wire [31:0] d_as, d_sh; // 1 1 1 SRA 
	// addsub32 (a,b,sub, s); 
	addsub32 as32 (a,b,aluc[2],d_as); // add/sub 
	// shift (d,sa, right, arith, sh); 
	shift shifter (b,a[4:0],aluc[2],1'b0,d_sh);
	// mux4x32 (a0, a1, a2, a3, s, y); 
	mux4x32 res (d_as,d_and_or,d_xor,d_sh,aluc[1:0],r); // alu result 
	assign z = ~|r; // z = (r == 0) 
endmodule

