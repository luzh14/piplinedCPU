`include"cla32.v"
module cla32_tb();

reg [31:0]a,b;
reg ci;
wire [31:0]s;

initial begin
ci=0;
a=0;b=4;#20
$display("s:%x",s);
a=4;#20
$display("s:%x",s);
a=8;#20
$display("s:%x",s);
a=12;#20
$display("s:%x",s);
a=16;#20
$display("s:%x",s);
end
cla32 dut(a,b,ci,s);

endmodule
