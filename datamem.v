module datamem (clk,dataout,datain,addr,we);
	input clk;
	input we;
	input [31:0] datain;
	input [31:0] addr;
	output [31:0] dataout;
	reg [31:0] ram[31:0];

parameter MEM_INIT="float_add_data.txt";

	assign dataout =  ram[addr[6:2]];
	always @(posedge clk) begin 
		if(we) begin
			ram[addr[6:2]] = datain;
		end
	end

	initial begin 
		$readmemh(MEM_INIT, ram);
	end

endmodule