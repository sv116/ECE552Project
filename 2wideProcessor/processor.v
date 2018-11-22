/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem_a,	 // O: The address of the data to get from imem a
	 address_imem_b,   // O: The address of the data to get from imem b
	 q_imem_a,			 // I: The data from imem
    q_imem_b,         // I: The data from imem
	 rden_a,           // O: read enable for a  might need this, might not we shall see
    rden_b,	          // O: read enable for b

    // Dmem
    address_imem_a,	 // O:  The address of the data to get or put from/to dmem a
	 address_imem_b,   // O:  The address of the data to get or put from/to dmem b
    data_a,           // O: The data to write to dmem a
	 data_b,				 // O: The data to write to dmem b
    wren_a,           // O: Write enable for dmem a
	 wren_b,           // O: Write enable for dmem b
    q_dmem_a,          // I: The data from dmem
	 q_dmem_b,          // I: The data from dmem
  
    // Regfile
    ctrl_writeEnable_a,             // O: Write enable for regfile a
	 ctrl_writeEnable_b,             // O: Write enable for regfile b
    ctrl_writeReg_a,                // O: Register to write to in regfile a
	 ctrl_writeReg_b,						// O: Register to write to in regfile b
    ctrl_readRegAa,                 // O: Register to read from port A of regfile for a
    ctrl_readRegBa,                 // O: Register to read from port B of regfile for a
	 ctrl_readRegAb,						// O: Register to read from port A of regfile for a
	 ctrl_readRegBb,						// O: Register to read from port B of regfile for a
    data_writeReg_a,                // O: Data to write to for regfile a
	 data_writeReg_b,                // O: Data to write to for regfile b
    data_readRegAa,                 // I: Data from port A of regfile a
    data_readRegBa,                 // I: Data from port B of regfile a
	 data_readRegAb,                 // I: Data from port A of regfile b
    data_readRegBb,                 // I: Data from port B of regfile b
	 	
	 cycles,
	 outputFD,
	 output_DX,
	 output_XM,
	 output_MW,
	 ALUSrc,
	 data_result, ALU_dataA, ALU_dataB, ALUop,
	 branchTaken, branchA, branchB,
	 muxBranchA, muxBranchB, less
     
);  
	//Cycle and instruction counter logic -- needs to be updated for two wide
	reg [31:0] cycl; 
	reg [31:0] cycle_count = 31'b0;
	always @(posedge clock)
	  begin
			  cycle_count <= cycle_count+1;
	  end
	output [31:0] cycles = cycle_count;
		
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

	 //testing outputs
	 wire [31:0] thisPC;
	 output [63:0] outputFD;
	 output [151:0] output_DX;
	 output [78:0] output_XM;
	 output [76:0] output_MW;
	 output ALUSrc;
	 //ctrl_pcTarget
    /* YOUR CODE STARTS HERE */
	 
	 
	 //initialize PC
	 wire [1:0] PCSrc;
	 wire [1:0] notPCSrc;
	 wire enPC0, enPC1, enPC2, enPC3;
	 wire FDWrite, PCWrite, DXWrite, XMWrite;
	 wire [31:0] nextJumpPC; //you could directly save it into latch input
	 wire [31:0]  nextPC, nP;
	 wire [31:0] NextPC, RDREG;
	 
	  not notPCS1(notPCSrc[0], PCSrc[0]);
	  not notPCS2(notPCSrc[1], PCSrc[1]);
	  and andPCS1(enPC0, notPCSrc[1], notPCSrc[0]);
	  and andPCS2(enPC1, notPCSrc[1], PCSrc[0]);
	  and andPCS3(enPC2, PCSrc[1], notPCSrc[0]);
	  and andPCS4(enPC3, PCSrc[1], PCSrc[0]);
	  
	  wire choose;
	  or andChoosePC(choose, enPC1, enPC2, enPC3);
	 
	 //tristate_buffer pc0(NextPC, enPC0, nextPC);
	 tristate_buffer pc1(nextJumpPC, enPC1, nextPC);
	 tristate_buffer pc2(target, enPC2, nextPC);
	 tristate_buffer pc3(RDREG, enPC0, nextPC); //print to see whats going on, pcsource not on stall but on flush logic goes on
	 
	 assign nP = choose ? nextPC : NextPC;
	 PC_register pc(clock, PCWrite, reset, thisPC, nP);
	 //calculate nextPC
	 wire of;
	 CLA_32bit addPC(thisPC, 32'b1, 1'b0, NextPC, of);
	 //get the instruction from imem	
	 assign address_imem = thisPC[11:0]	;
	 
	 // F/D latch
	 wire FD_flush3, fd_en, FD_flush1, FD_flush2, FD_flush4;
	 wire FD_flush;
	 wire [63:0] inputFD;// outputFD;
	 assign inputFD[31:0] = FD_flush ? 32'd0 : q_imem;
	 assign inputFD[63:32] = NextPC;
	// assign fd_en = FDWrite ? 1'b0 : 1'b1;
	
	//////////////////////////////////////////////////////////////
	/////////FD LATCH ////////////////////////////////////////////
	 FD_latch fd(clock, FDWrite, reset, outputFD, inputFD);
	
    //Decode stage 
	 wire [4:0] opcode, rd, rs, rt;
	 wire [16:0] immediate;
	 wire [31:0] immediateX;
	 wire [26:0] target;
	 wire noop;
	 instruction_splitter split(outputFD[31:0], opcode, rd, rs, rt, immediate, target); 
    sign_extend sx(immediate, immediateX);
	 assign noop = outputFD[31:0]==32'b0 ? 1'b1 : 1'b0; 
	 
	 //nextPC +immediate
	  wire o;
	  CLA_32bit addPCIm(outputFD[63:32], immediateX, 1'b0, nextJumpPC, o);
	  
	 //instruction decoder
	 wire i0, i1, i2, i3, i4, i5, i6, i7, i8, i21, i22;
	 wire branch, JP, JR, JAL, MemRead, MemWrite,MemToReg;
	 wire regWrite;
	 wire control;
	 instruction_decoder IR(opcode,i0, i1, i2, i3, i4, i5, i6, i7, i8, i21, i22);

	 //hazard checking
	 wire bex, setx;
	             //MemRead                                              dx-rd                                     xm-rd              xm-memread
	 hazardLogic hl(JR, bex, output_DX[142], clock, reset, output_DX[148], output_DX[36:32], output_DX[41:37], rt, rs, rd, output_XM[73:69],
	 branch, output_XM[78], FDWrite, PCWrite, DXWrite, XMWrite, control, output_DX[6:2], data_resultRDY);
	 controller C(i0, i1, i2, i3, i4, i5, i6, i7, i8, i21, i22, control, regWrite, ALUSrc, 
                  branch, JP, JR, JAL, MemRead, MemWrite, MemToReg, bex, setx); 
	 wire ctrl_pcTarget;
    or ortarget(ctrl_pcTarget, JAL, JP);
	 //execute controls
	 //aluSrc, ALUop, 
	 //memory controls
	 //branch, MemWrite, MemRead
	 //write controls
	 //MemtoReg, regWrite
	  
	 //Get data from register file
	 wire [4:0] readA = bex ? 5'd30 : rs;
	 assign ctrl_readRegA = readA;
	 wire BorJR;
	 or orBBB(BorJR, branch, JR);
    assign ctrl_readRegB =  BorJR ? rd : rt;                  
    wire [31:0] dataA;
	 wire [31:0] dataB;
	 assign dataA = data_readRegA;
	 assign dataB = data_readRegB;
	 
	 //equal unit
	 //bypass values from XM, MW, bypassing here data a and B
	 //flush instr in FD
	 //where does dataA come from, what about B? rd, rs
	 
	 //choose first input
	  output [31:0] branchA, branchB;
	  output [1:0] muxBranchA, muxBranchB;
	  wire [1:0] notBranchA, notBranchB;
	  wire enC0, enC1, enC2, enC3, enC4, enC5;
	  not notBcA1(notBranchA[0], muxBranchA[0]);
	  not notBcA2(notBranchA[1], muxBranchA[1]);
	  
	  and andBcA1(enC0, notBranchA[1], notBranchA[0]);
	  and andBcA2(enC1, notBranchA[1], muxBranchA[0]);
	  and andBcA3(enC2, muxBranchA[1], notBranchA[0]);
	  
	  tristate_buffer tbC1(dataA,           enC0, branchA);
	  tristate_buffer tbC2(data_writeReg,   enC1, branchA);
	  tristate_buffer tbC3(output_XM[31:0], enC2, branchA);
	  
	 //choose second input
	  not notBcB1(notBranchB[0], muxBranchB[0]);
	  not notBcB2(notBranchB[1], muxBranchB[1]);
	  and andBcB1(enC3, notBranchB[1], notBranchB[0]);
	  and andBcB2(enC4, notBranchB[1], muxBranchB[0]);
	  and andBcB3(enC5, muxBranchB[1], notBranchB[0]);
	  
	  tristate_buffer tbC4(dataB,           enC3, branchB);
	  tristate_buffer tbC5(data_writeReg,   enC4, branchB);
	  tristate_buffer tbC6(output_XM[31:0], enC5, branchB);
	 
	 wire  notEqual1, bnetaken, blttaken, lessThan1;
	 output less;
	 output branchTaken;
	 wire [1:0] pcSource, pcSource2, pcSource3, pcSource4;
	 assign less = ($signed(branchB) < $signed(branchA));
	 branchCalc bcalc(branchB, branchA, notEqual1, lessThan1); 
    
	 and andbne(bnetaken, i2, notEqual1);
	 and andblt(blttaken, i6, less);
	 or orbranch(branchTaken, bnetaken, blttaken);
	 //addapt pcSrc and flushing
	 
	//jump taken? bex
	  wire [31:0] rstatus;
	  wire [1:0] notBex, bexMux;
	  wire enBx0, enBx1, enBx2;
	  not notstat1(notBex[0], bexMux[0]);
	  not notstat2(notBex[1], bexMux[1]);
	  and andBxx1(enBx0, notBex[1], notBex[0]);
	  and andBxx2(enBx1, notBex[1], bexMux[0]);
	  and andBxx3(enBx2, bexMux[1], notBex[0]);
	  
	  tristate_buffer tbX4(dataA,           enBx0, rstatus);
	  tristate_buffer tbX5(data_writeReg,   enBx1, rstatus);
	  tristate_buffer tbX6(output_XM[31:0], enBx2, rstatus);
	  
	  wire  bexTaken;
	  wire bexTaken1, bexTaken2;
	  branchCalc cb(rstatus, 32'b0, bexTaken1,bexTaken2);
	 
	   and andbcb(bexTaken, i22, bexTaken1);
		
	  //assign bexTaken1 = (rstatus==32'b0) ? 1'b0 : 1'b1;
	 // and andBexT(bexTaken, bexTaken1, output_DX[149]);
	  wire [31:0] rdReg;
	  wire [1:0] jrMux;
	  wire [1:0] not_jrMux;
	  wire enJ0, enJ1, enJ2;
	  not notj1(not_jrMux[0],jrMux[0]);
	  not notj2(not_jrMux[1], jrMux[1]);
	  and andj1(enJ0, not_jrMux[1], not_jrMux[0]);
	  and andj2(enJ1, not_jrMux[1], jrMux[0]);
	  and andj3(enJ2, jrMux[1], not_jrMux[0]);
	  
	  tristate_buffer tbj0(dataA,           enJ0, rdReg);
	  tristate_buffer tbj1(data_writeReg,   enJ1, rdReg);
	  tristate_buffer tbj2(output_XM[31:00], enJ2, rdReg);
	  wire [31:0] out;
	  
	  //Tflipflop tff(clock, clock, reset, out);
	  //PC_register  rrrd(clock, 1'b1, reset, out, rdReg);
	  PC_register  rrd(~clock, 1'b1, reset, RDREG, rdReg);
	 //flush logic
	 and andFlush(FD_flush1, branchTaken, immediateX!=32'd0);
	 and andFlush2(FD_flush2, ctrl_pcTarget, target!=outputFD[63:32]);
	 and andFlush3(FD_flush3, bexTaken, target!=outputFD[63:32]);
	 and andFLush4(FD_flush4, i4, rdReg!=outputFD[63:32]);
	 or   orFlush(FD_flush, FD_flush1, FD_flush2, FD_flush3, FD_flush4);
	 
	 assign pcSource = branchTaken ? 2'b1: 2'b0; //for branches mux select is one
	 assign pcSource2 = ctrl_pcTarget ? 2'd2 : pcSource; // for target jumps mux select is 2, JAL, JP
	 assign pcSource3 = bexTaken ? 2'd2 : pcSource2;
	 wire jri4;
	 or i44(jri4, i4, output_DX[150]);
	 assign pcSource4 = i4 ?  2'd3 : pcSource3; //JR assigns 3
	 //calculation of PCSrc
	 wire [1:0] PCSrc1;
    dffe_ref df(PCSrc[0], pcSource4[0], ~clock, 1'b1, reset);
	 dffe_ref df1(PCSrc[1], pcSource4[1], ~clock, 1'b1, reset);
	 //dffe_ref dff(PCSrc[0], PCSrc1[0], ~clock, 1'b1, reset);
	 //dffe_ref dff1(PCSrc[1], PCSrc1[1], ~clock, 1'b1, reset);
	 wire [4:0] rdest1, rdest, rsource; 
	 wire [31:0] immed1, immed;
	 wire [31:0] set;
	 assign set[26:0] = target;
	 assign set[27] = set[26];
	 assign set[28] = set[26];
	 assign set[29] = set[26];
	 assign set[30] = set[26];
	 assign set[31] = set[26];
	 wire orD;
	 assign rdest1 = JAL ? 5'd31 :5'd30;
	 or ordest(orD, JAL, setx);
	 assign rdest = orD ? rdest1 :rd; 
	 
	 assign rsource = orD ? 5'b0 : rs;
	 assign immed1 = JAL ? outputFD[63:32] :set;
	 assign immed = orD ? immed1 : immediateX;
	 wire aluZero;
	 or orALUzero(aluZero, i5, i3, i21, i7, i8);
	 
    // D/X latch
	  wire [151:0] input_DX;

	  assign input_DX[151] = i5;
	  assign input_DX[150] = i4;
	  assign input_DX[149] = bex;
	  assign input_DX[148] = MemRead;
	  assign input_DX[147] = noop;
	  assign input_DX[146] = MemWrite;
	  assign input_DX[145] = JAL; 
	  assign input_DX[144] = JR; 
	  assign input_DX[143] = aluZero; //for selecting the alu mux opcode
	  assign input_DX[142] = regWrite;
	  assign input_DX[141] = MemToReg;
	  assign input_DX[140] = JP;
	  assign input_DX[139] = branch;
	  assign input_DX[138] = ALUSrc;
	  assign input_DX[137:106] = outputFD[63:32]; //nextPC
	  assign input_DX[105:74] = dataA;
	  assign input_DX[73:42] = dataB;  
	  assign input_DX[41:37] = rdest;  //this for bypassing and jump
	  assign input_DX[36:32] = rsource;
	  assign input_DX[31:0] = immed;
	 
	  DX_latch DX(clock, DXWrite, reset, output_DX, input_DX);
	 
	 //execute stage 
	
	  
	     
	  //instantiate ALU, pass in the opcode, have a mux that chooses btw the aluop and zero, select is addi
	  wire [31:0] ALU_dataB1;
	  output [31:0] data_result, ALU_dataA, ALU_dataB;
	  output [4:0] ALUop;
	  wire isNotEqual, isLessThan, overflow, en0, en1, en2, enB0, enB1, enB2;
	  wire [1:0] notALUinA1, notALUinB1;
	  //choose second input, either imm for addi or dataB from reg file
	  assign ALU_dataB1 = output_DX[138] ? output_DX[31:0] : output_DX[73:42];
	  
	  //bypass tristate buffers
	  not notalB1(notALUinB1[0], ALUinB[0]);
	  not notalB2(notALUinB1[1], ALUinB[1]);
	  and andalB1(enB0, notALUinB1[1], notALUinB1[0]);
	  and andalB2(enB1, notALUinB1[1],     ALUinB[0]);
	  and andalB3(enB2,     ALUinB[1], notALUinB1[0]);
	  
	  tristate_buffer tbB1(ALU_dataB1,     enB0, ALU_dataB);
	  tristate_buffer tbB2(data_writeReg,  enB1, ALU_dataB);
	  tristate_buffer tbB3(output_XM[31:0],enB2, ALU_dataB);
	  
	  
	  //either zeros for addi or regular aluopcode
	  assign ALUop = output_DX[143] ? 5'b0 : output_DX[6:2]; 
	  
	  //choose first input
	  
	  not notalA1(notALUinA1[0], ALUinA[0]);
	  not notalA2(notALUinA1[1], ALUinA[1]);
	  and andalA1(en0, notALUinA1[1], notALUinA1[0]);
	  and andalA2(en1, notALUinA1[1],     ALUinA[0]);
	  and andalA3(en2,     ALUinA[1], notALUinA1[0]);
	  
	  tristate_buffer tb1(output_DX[105:74], en0, ALU_dataA);
	  tristate_buffer tb2(data_writeReg,     en1, ALU_dataA);
	  tristate_buffer tb3(output_XM[31:0],   en2, ALU_dataA);
	  
	  wire data_resultRDY, data_exception;
	  
	  alu ALU(clock, ALU_dataA, ALU_dataB, ALUop, output_DX[11:7], data_result, isNotEqual, isLessThan, overflow, dataRDY, data_exception);
		  //later add mult div to your ALU
	     //include exception rstatus
	  wire dataRDY;  
	  wire [4:0] destRD = o ? 5'd30 : output_DX[41:37];
	  dffe_ref dfff(data_resultRDY, dataRDY, ~clock, 1'b1, reset);
	  wire isAddi, notAddi, isAdd, isSub;
	  not notAdi(notAddi, isAddi);
	  wire zeroOp = (ALUop==5'b0);
	  and alucheck(isAddi, output_DX[151], zeroOp);  
	  and aluCheck1(isAdd, zeroOp, notAddi);
	  assign isSub = (ALUop==5'b1);
	  wire [31:0] result, latch_result;
	 
	  
	   tristate_buffer tovf(32'b1, isAdd, result);
		tristate_buffer tovf1(32'd2, isAddi, result);
		tristate_buffer tovf2(32'd3, isSub, result);
		
	 assign latch_result = o ? result : data_result;
	  
	// X/M latch
	   wire XM_MemWrite, XM_MemToReg, XM_regWrite,XM_JAL,XM_JR, XM_JP, XM_branch;
		wire [31:0] XM_NextJumpPc, XM_rd, XM_rs, XM_dataB;
		
		wire[78:0] input_XM;// output_XM;
		/*assign input_XM[114] = output_DX[148];//MemRead
		assign input_XM[113] = output_DX[147];// noop
		assign input_XM[112] = output_DX[146]; //MemWrite
		assign input_XM[111] = output_DX[141]; //MemToReg
		assign input_XM[110] = output_DX[142]; //regWrite
		assign input_XM[109] = output_DX[145]; //JAL
		assign input_XM[108] = output_DX[144]; //JR
      assign input_XM[107] = output_DX[140]; //JP
		assign input_XM[106] = output_DX[139]; //branch
		assign input_XM[105:74] = nextJumpPC; //nextJumpPc*/
		assign input_XM[78] = output_DX[148];//MemRead
		assign input_XM[77] = output_DX[147];// noop
		assign input_XM[76] = output_DX[146]; //MemWrite
		assign input_XM[75] = output_DX[141]; //MemToReg
		assign input_XM[74] = output_DX[142]; //regWrite
		assign input_XM[73:69] = destRD; // rd; //rd should be choose btw rstatus and previous one
		assign input_XM[68:64] = output_DX[36:32]; //rs
		assign input_XM[63:32] = ALU_dataB; //dataB
		assign input_XM[31:0] = latch_result; //ALU result
		
		XM_latch XM(clock, XMWrite, reset, output_XM, input_XM);
		
/**********************************************************************************************
*******************/// memory stage/////*****************************************************/

	   wire [31:0] dmem_data;
	  //calculation of PCSrc
	  // and andBranch(PCSrc, output_XM[0],output_XM[106]); //this will need to be extended to include jumps
	  
	  //output inputs to dmem and get the outputs -> read data save it to the latch
	  assign address_dmem = output_XM[11:0];
	  assign data = muxM ?  data_writeReg  : output_XM[31:0];
	  assign wren = output_XM[76];
	  assign dmem_data = q_dmem;
	 
	 // M/W latch
	  wire[76:0] input_MW;// output_MW;
	  
	  assign input_MW[76] = output_XM[77]; //noop
	  assign input_MW[75] = output_XM[75]; //MemToReg
	  assign input_MW[74] = output_XM[74];//regWrite
	  assign input_MW[73:69] = output_XM[73:69]; //rd
	  assign input_MW[68:64] = output_XM[68:64]; //rs
	  assign input_MW[63:32] = dmem_data; //data from memory
	  assign input_MW[31:0] = output_XM[31:0]; //ALU result
	  
	  MW_latch MW(clock, 1'b1, reset, output_MW, input_MW);
	  
	  
	 //writeback
	 assign data_writeReg = output_MW[75] ? output_MW[63:32] : output_MW[31:0];
	 assign ctrl_writeEnable = output_MW[74];
	 assign ctrl_writeReg = output_MW[76] ? 5'b0 : output_MW[73:69];
	 
	 //bypass logic
	  wire [1:0] ALUinA, ALUinB;
	  wire muxM;
     bypassLogic bpl(output_MW[74], output_XM[74], output_XM[76], output_MW[75], output_DX[36:32], output_DX[16:12],
	               output_XM[73:69], output_MW[73:69], rs, rd, ALUinA, ALUinB, muxM, muxBranchA, muxBranchB, bexMux, jrMux);
endmodule
