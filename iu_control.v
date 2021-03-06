module iu_control (op,func,rs,rt,fs,ft,rsrtequ,ewfpr,ewreg,em2reg,ern,mwfpr, 
				   mwreg,mm2reg,mrn,e1w,e1n,e2w,e2n,e3w,e3n,stall_div_sqrt, 
				   st,pcsrc,wpcir,wreg,m2reg,wmem,jal,aluc,aluimm,shift, 
				   sext,regrt,fwda,fwdb,swfp,fwdf,fwdfe,wfpr,fwdla,fwdlb, 
				   fwdfa,fwdfb,fc,wf,fasmds,stall_lw,stall_fp,stall_lwc1, 
				   stall_swc1); 
input rsrtequ, ewreg,em2reg,ewfpr, mwreg,mm2reg,mwfpr; 
input e1w,e2w,e3w,stall_div_sqrt,st; 
input [5:0] op,func;

input [4:0] rs,rt,fs,ft,ern,mrn,e1n,e2n,e3n; 
output wpcir,wreg,m2reg,wmem,jal,aluimm,shift,sext,regrt; 
output swfp,fwdf,fwdfe; 
output fwdla,fwdlb,fwdfa,fwdfb; 
output wfpr,wf,fasmds; 
output [2:0] aluc; 
output [2:0] fc; 
output [1:0] pcsrc,fwda,fwdb; 
output stall_lw,stall_fp,stall_lwc1,stall_swc1; 
//wire rtype,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra; 
//wire i_jr,i_j,i_jal; 
//wire i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui; 
//wire ftype,i_lwc1,i_swc1,i_fadd,i_fsub,i_fmul,i_fdiv,i_fsqrt; 

// r format 
wire rtype =~|op; 
wire i_add = rtype& func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];
wire i_sub = rtype& func[5]&~func[4]&~func[3]&~func[2]&func[1]&~func[0];
wire i_and = rtype& func[5]&~func[4]&~func[3]&func[2]&~func[1]&~func[0];
wire i_or = rtype& func[5]&~func[4]&~func[3]&func[2]&~func[1]&func[0];
wire i_xor = rtype& func[5]&~func[4]&~func[3]&func[2]&func[1]&~func[0];

 // i format 
wire i_addi = ~op[5]&~op[4]& op[3]&~op[2]&~op[1]&~op[0];
wire i_lw = op[5]&~op[4]&~op[3]&~op[2]& op[1]& op[0];
wire i_sw = op[5]&~op[4]& op[3]&~op[2]& op[1]& op[0];
wire i_beq = ~op[5]&~op[4]&~op[3]& op[2]&~op[1]&~op[0];

 // j format 
 wire i_j = ~op[5]&~op[4]&~op[3]&~op[2]& op[1]& ~op[0];

 // f format 
 wire ftype = ~op[5]&op[4]&~op[3]&~op[2]&~op[1]&op[0];
 wire i_lwc1 = op[5]&op[4]&~op[3]&~op[2]&~op[1]&op[0];
 wire i_swc1 = op[5]&op[4]&op[3]&~op[2]&~op[1]&op[0];
 wire i_fadd = ftype&~func[5]&~func[4]&~func[3]&~func[2]&~func[1]&~func[0];

 wire i_rs = i_add | i_sub | i_and | i_or | i_xor | i_addi | i_lw | i_sw | i_beq | i_lwc1 | i_swc1; 
 wire i_rt = i_add | i_sub | i_and | i_or | i_xor | i_sw | i_beq;

 assign stall_lw = ewreg & em2reg & (ern != 0) & (i_rs & (ern == rs) | i_rt & (ern == rt)); 

 reg [1:0] fwda, fwdb; 
 always @ (ewreg or mwreg or ern or mrn or em2reg or mm2reg or rs or rt) begin 
 	fwda = 2'b00; // default: no hazards 
	 if (ewreg & (ern != 0) & (ern == rs) &~em2reg) begin 
	 	fwda = 2'b01; // select exe_alu 
	 end else begin 
	 	if (mwreg & (mrn != 0) & (mrn == rs) & ~mm2reg) begin 
	 		fwda = 2'b10; // select mem_alu 
	 	end else begin 
	 		if (mwreg & (mrn != 0) & (mrn == rs) & mm2reg) begin 
	 			fwda = 2'b11; // select mem_lw 
	 		end 
	 	end 
	 end 
	 fwdb = 2'b00; // default: no hazards 
	 if (ewreg & (ern != 0) & (ern == rt) & ~em2reg) begin 
	 	fwdb = 2'b01; // select exe_alu 
	 end else begin 
	 	if (mwreg & (mrn != 0) & (mrn == rt) & ~mm2reg) begin 
	 		fwdb = 2'b10; // select mem_alu 
	 	end else begin 
	 		if (mwreg & (mrn != 0) & (mrn == rt) & mm2reg) begin 
	 			fwdb = 2'b11; // select mem_lw 
	 		end 
	 	end 
	end 
end

//generate control signals
 assign wreg = (i_add|i_sub|i_and|i_or|i_xor|i_addi|i_lw)&wpcir;
 assign regrt = i_addi|i_lw|i_lwc1;
 assign m2reg = i_lw;
 assign aluimm = i_addi | i_lw | i_sw | i_lwc1 | i_swc1;
 assign sext = i_addi | i_lw | i_sw | i_beq | i_lwc1 | i_swc1;
 assign aluc[2] = i_sub|i_or|i_beq;
 assign aluc[1] = i_xor|i_beq;
 assign aluc[0] = i_and|i_or;
 assign wmem = (i_sw | i_swc1) & wpcir;
 assign pcsrc[1] = i_j;
 assign pcsrc[0] = i_beq & rsrtequ | i_j;
 assign shift = 0;
 assign jal = 0;

 wire [2:0]fop;	//fpu control code
 assign fop[0] = 0;
 assign fop[1] = 0;
 assign fop[2] = 0;

 //stall caused by fp data harzards
 wire i_fs = i_fadd;
 wire i_ft = i_fadd;

 assign stall_fp = (e1w & (i_fs & (e1n == fs) | i_ft & (e1n == ft))) |
 				   (e2w & (i_fs & (e2n == fs) | i_ft & (e2n == ft)));
 assign fwdfa = e3w & (e3n == fs);
 assign fwdfb = e3w & (e3n == ft);
 assign wfpr  = i_lwc1 & wpcir;
 assign fwdla = mwfpr & (mrn == fs);
 assign fwdlb = mwfpr & (mrn == ft);
 assign stall_lwc1 = ewfpr & (i_fs & (ern == fs) | i_ft & (ern == ft));
 assign swfp = i_swc1;
 assign fwdf = swfp & e3w & (ft == e3n);
 assign fwdfe = swfp & e2w & (ft == e2n);
 assign stall_swc1 = swfp & e1w & (ft == e1n);
 wire stall_others = stall_lw | stall_fp | stall_lwc1 | stall_swc1| st;
 assign wpcir = ~stall_others; 
 assign fc = fop & {3{~stall_others}}; 
 assign wf = i_fs & wpcir;
 assign fasmds = i_fs;

 endmodule // iu_control