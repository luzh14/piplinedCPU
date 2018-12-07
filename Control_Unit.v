module Control_Unit (op,func,z,wreg,regrt,m2reg,shift,aluimm,aluc,wmem,pcsrc,sext);
	input [5:0]op;   // func
	input [5:0]func; // op
	input z;			//alu zero tag
	output wreg; 		//write regfile
	output regrt; 	    //dest reg number is rt
	output m2reg; 		
	output shift; 		//instruction is a shift
	output aluimm; 	    //alu input b is an i32
	output [2:0] aluc;  //alu zero operatiton control
	output wmem; 		//write data memory
	output [1:0] pcsrc; //select pc source
	output sext;

// r format 
wire rtype =~|op; 
wire i_add = rtype& func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];
wire i_sub = rtype& func[5]&~func[4]&~func[3]&~func[2]&func[1]&~func[0];
wire i_and = rtype& func[5]&~func[4]&~func[3]&func[2]&~func[1]&~func[0];
wire i_or = rtype& func[5]&~func[4]&~func[3]&func[2]&~func[1]&func[0];

 // i format 
wire i_addi = ~op[5]&~op[4]& op[3]&~op[2]&~op[1]&~op[0];
wire i_lw = op[5]&~op[4]&~op[3]&~op[2]& op[1]& op[0];
wire i_sw = op[5]&~op[4]& op[3]&~op[2]& op[1]& op[0];
wire i_beq = ~op[5]&~op[4]&~op[3]& op[2]&~op[1]&~op[0];

 // j format 
 wire i_j = ~op[5]&~op[4]&~op[3]&~op[2]& op[1]& ~op[0];

 //generate control signals
 assign wreg = i_add|i_sub|i_and|i_or|i_addi|i_lw;
 assign regrt = i_addi|i_lw;
 assign m2reg = i_lw;
 assign aluimm = i_addi|i_lw|i_sw;
 assign sext = i_addi | i_lw | i_sw | i_beq;
 assign aluc[2] = i_sub|i_or|i_beq;
 assign aluc[1] = 0;
 assign aluc[0] = i_and|i_or;
 assign wmem = i_sw;
 assign pcsrc[1] = i_j;
 assign pcsrc[0] = i_beq & z | i_j;
 assign shift = 0;
endmodule