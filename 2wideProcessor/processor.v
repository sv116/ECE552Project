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
    address_dmem_a,	 // O:  The address of the data to get or put from/to dmem a
	 address_dmem_b,   // O:  The address of the data to get or put from/to dmem b
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
	 output [11:0] address_imem_a;
	 output [11:0] address_imem_b;
	 input [31:0] q_imem_a;			
    input [31:0] q_imem_b;       
	 output rden_a;           
    output rden_b;	          

    // Dmem
	 output [11:0] address_dmem_a;	 
	 output [11:0] address_dmem_b;   
    output [31:0] data_a;           
	 output [31:0] data_b;				 
    output wren_a;          
	 output wren_b;          
    input [31:0] q_dmem_a;     
	 input [31:0] q_dmem_b; 
	 
    // Regfile
	 
	 output ctrl_writeEnable_a;
	 output ctrl_writeEnable_b;
    output [4:0] ctrl_writeReg_a;
	 output [4:0] ctrl_writeReg_b;
    output [4:0] ctrl_readRegAa;
    output [4:0] ctrl_readRegBa;
	 output [4:0] ctrl_readRegAb;
	 output [4:0] ctrl_readRegBb;
    output [31:0] data_writeReg_a;
	 output [31:0] data_writeReg_b;
    input [31:0] data_readRegAa;
    input [31:0] data_readRegBa;
	 input [31:0] data_readRegAb;
    input [31:0] data_readRegBb;

	 //testing outputs
	 wire [31:0] thisPC;
	 output [95:0] outputFD;
	 output [271:0] output_DX;
	 output [157:0] output_XM;
	 output [153:0] output_MW;
	 output ALUSrc;
	 //ctrl_pcTarget
	 
	 
	 /////////////////////////////////////////////////////////////////////////////////////////////////////////
    /****************************** FETCH *****************************************************************/
	 ////////////////////////////////////////////////////////////////////////////////////////////////////////
	 
	 //initialize PC
	 wire [1:0] PCSrc;
	 wire [1:0] notPCSrc;
	 wire enPC0, enPC1, enPC2, enPC3;
	 wire FDWrite, PCWrite, DXWrite, XMWrite;
	 wire [31:0] nextJumpPC, nextJumpPC2; //you could directly save it into latch input
	 wire [31:0]  nextPC, nP;
	 wire [31:0] NextPC, RDREG;
	 
	 /// comes from the end of the execute stage
	  not notPCS1(notPCSrc[0], PCSrc[0]);
	  not notPCS2(notPCSrc[1], PCSrc[1]);
	  and andPCS1(enPC0, notPCSrc[1], notPCSrc[0]);
	  and andPCS2(enPC1, notPCSrc[1], PCSrc[0]);
	  and andPCS3(enPC2, PCSrc[1], notPCSrc[0]);
	  and andPCS4(enPC3, PCSrc[1], PCSrc[0]);
	  
	  //Choosing the correct next PC among PC+1, PC+1+N, Target or Register jump
	  wire choose;
	  or orChoosePC(choose, enPC1, enPC2, enPC3);
	 
	 //tristate_buffer pc0(NextPC, enPC0, nextPC);
	 tristate_buffer pc1(nextJumpPC, enPC1, nextPC);
	 tristate_buffer pc2(target, enPC2, nextPC);
	 tristate_buffer pc3(RDREG, enPC0, nextPC); //print to see whats going on, pcsource not on stall but on flush logic goes on
	
	 assign nP = choose ? nextPC : NextPC;
	 PC_register pc(clock, PCWrite, reset, thisPC, nP);
	 
	 //PC +1
	 wire [31:0] pcPlus1 = thisPC +32'b1;
	 //calculate nextPC = PC+2
	 wire of;
	 CLA_32bit addPC(thisPC, 32'd2, 1'b0, NextPC, of);
	 //get the instruction from imem	
	 assign rden_a = 1'b1;
	 assign rden_b = 1'b1;
	 assign address_imem_a = thisPC[11:0];
	 assign address_imem_b = pcPlus1[11:0];
	 
	 // F/D latch
	 wire FD_flush3, FD_flush1, FD_flush2, FD_flush4;
	 wire FD_flush;
	
	/////////////////////////////////////////////////////////
	//****************** FD LATCH **********************////
	///////////////////////////////////////////////////////
	
	 wire [95:0] inputFD;// outputFD;
	 assign inputFD[31:0] = FD_flush ? 32'd0 : q_imem_a;
	 assign inputFD[63:32] = NextPC;
	 assign inputFD[95:64] = FD_flush ? 32'd0 : q_imem_b;
	 
	 FD_latch fd(clock, FDWrite, reset, outputFD, inputFD);
	 
	 /////////////////////////////////////////////////////////////////////////////////////////////////////
    /********************************** DECODE Stage **************************************************/
	////////////////////////////////////////////////////////////////////////////////////////////////////
	 
	 wire [4:0] opcode, rd, rs, rt, opcode2, rd2, rs2, rt2;
	 wire [16:0] immediate, immediate2;
	 wire [31:0] immediateX, immediateX2;
	 wire [26:0] target, target2;
	 wire noop, noop2;
	 
	 
	 instruction_splitter split(outputFD[31:0], opcode, rd, rs, rt, immediate, target);
	 instruction_splitter split2(outputFD[95:64], opcode2, rd2, rs2, rt2, immediate2, target2);
	
    sign_extend sx(immediate, immediateX);
	 sign_extend sx2(immediate2, immediateX2);
	 
	 assign noop  = outputFD[31:0] == 32'b0 ? 1'b1 : 1'b0; 
	 assign noop2 = outputFD[95:64]== 32'b0 ? 1'b1 : 1'b0;
	 
	 
	 //nextPC +immediate
	  wire o, o2;
	  CLA_32bit addPCIm(outputFD[63:32], immediateX, 1'b0, nextJumpPC, o);
	  CLA_32bit addPCIm2(outputFD[63:32], immediateX2, 1'b0, nextJumpPC2, o2);
	  
	 //instruction decoder
	 wire i0, i1, i2, i3, i4, i5, i6, i7, i8, i21, i22;
	 wire in0, in1, in2, in3, in4, in5, in6, in7, in8, in21, in22;
	 wire branch, JP, JR, JAL, MemRead, MemWrite,MemToReg;
	 wire branch2, JP2, JR2, JAL2, MemRead2, MemWrite2, MemToReg2;
	 wire regWrite, regWrite2;
	 wire control, control2;
	 wire ALUSrc2;
	 
	 instruction_decoder IR(opcode,i0, i1, i2, i3, i4, i5, i6, i7, i8, i21, i22);
	 instruction_decoder IR2(opcode2,in0, in1, in2, in3, in4, in5, in6, in7, in8, in21, in22);

	 //hazard checking
	 wire bex, setx, bex2, setx2;
	 
	             //MemRead                                              dx-rd                                     xm-rd              xm-memread
	 hazardLogic hl(JR, bex, output_DX[142], clock, reset, output_DX[148], output_DX[36:32], output_DX[41:37], rt, rs, rd, output_XM[73:69],
						branch, output_XM[78], FDWrite, PCWrite, DXWrite, XMWrite, control, output_DX[6:2], data_resultRDY);
						
						
	 controller C(i0, i1, i2, i3, i4, i5, i6, i7, i8, i21, i22, control, regWrite, ALUSrc, 
                  branch, JP, JR, JAL, MemRead, MemWrite, MemToReg, bex, setx); 
						
	   /* !!! */
	 //control 2 should be on if older instruction is changing PC, like jumps so that newer one is nooped
	 controller C2(in0, in1, in2, in3, in4, in5, in6, in7, in8, in21, in22, control2, regWrite2, ALUSrc2, 
                  branch2, JP2, JR2, JAL2, MemRead2, MemWrite2, MemToReg2, bex2, setx2); 		
						
	 wire ctrl_pcTarget;
    or ortarget(ctrl_pcTarget, JAL, JP);
	 
	 wire ctrl_pcTarget2;
    or ortarget2(ctrl_pcTarget2, JAL2, JP2);
	 //should we only have one pc target at the end,
	// I mean if you have older instruction and younger instruction both jumping to a target you only take older 	 
	 
	 //execute controls
	 //aluSrc, ALUop, 
	 //memory controls
	 //branch, MemWrite, MemRead
	 //write controls
	 //MemtoReg, regWrite
	  
	 //Get data from register file for line 1
	 wire [4:0] readA = bex ? 5'd30 : rs;
	 assign ctrl_readRegAa = readA;
	 
	 wire BorJR;
	 or orBBB(BorJR, branch, JR);
    assign ctrl_readRegBa =  BorJR ? rd : rt;  
	 
    wire [31:0] dataA;
	 wire [31:0] dataB;
	 assign dataA = data_readRegAa;
	 assign dataB = data_readRegBa;
	 
	 
	 //get data from register file for line 2
	 wire [4:0] readA2 = bex2 ? 5'd30 : rs2;
	 assign ctrl_readRegAb = readA2;
	 
	 wire BorJR2;
	 or orBBB2(BorJR2, branch2, JR2);
    assign ctrl_readRegBb =  BorJR2 ? rd2 : rt2;  
	 
    wire [31:0] dataA2;
	 wire [31:0] dataB2;
	 assign dataA2 = data_readRegAb;
	 assign dataB2 = data_readRegBb;
	 
	 
	 //equal unit
	 //bypass values from XM, MW, bypassing here data a and B
	 //flush instr in FD
	 //where does dataA come from, what about B? rd, rs
	 
	 //choose first input for branch comparison for line 1
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
	  tristate_buffer tbC2(data_writeReg_a,   enC1, branchA);
	  tristate_buffer tbC3(output_XM[31:0], enC2, branchA);
	  
	  //choose first input to branch comparison for line 2
	  // for now only the values from regfile - later add bypassing
	  wire [31:0] branchA2, branchB2;
	  assign branchA2 = dataA2;
	  assign branchB2 = dataB2;
	  
	  
	 //choose second input
	  not notBcB1(notBranchB[0], muxBranchB[0]);
	  not notBcB2(notBranchB[1], muxBranchB[1]);
	  and andBcB1(enC3, notBranchB[1], notBranchB[0]);
	  and andBcB2(enC4, notBranchB[1], muxBranchB[0]);
	  and andBcB3(enC5, muxBranchB[1], notBranchB[0]);
	  
	  tristate_buffer tbC4(dataB,           enC3, branchB);
	  tristate_buffer tbC5(data_writeReg_a,   enC4, branchB);
	  tristate_buffer tbC6(output_XM[31:0], enC5, branchB);
	
	 wire  notEqual1, bnetaken, blttaken;
	 output less;
	 output branchTaken;
	 
	 
	 assign less = ($signed(branchB) < $signed(branchA));
	 assign notEqual1 = $signed(branchB)==$signed(branchA);
	// branchCalc bcalc(branchB, branchA, notEqual1, lessThan1); 
    
	 and andbne(bnetaken, i2, notEqual1);
	 and andblt(blttaken, i6, less);
	 or orbranch(branchTaken, bnetaken, blttaken);
	 //addapt pcSrc and flushing
	 
	 //branch calculation for line 2
	 wire notEqual2, bnetaken2, blttaken2, lessThan2;
	 wire less2;
	 wire branchTaken2;
	 assign less2 = ($signed(branchB2) < $signed(branchA2));
	 assign notEqual2 = $signed(branchB2)==$signed(branchA2);
	 
	 and andbne2(bnetaken2, in2, notEqual2);
	 and andblt2(blttaken2, in6, less2);
	 or orbranch2(branchTaken2, bnetaken2, blttaken2);
	 
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
	  tristate_buffer tbX5(data_writeReg_a,   enBx1, rstatus);
	  tristate_buffer tbX6(output_XM[31:0], enBx2, rstatus);
	  
	  //bex for line 1
	  wire  bexTaken;
	  wire bexTaken1;
	  //branchCalc cb(rstatus, 32'b0, bexTaken1, bexTaken2);
	  assign bexTaken1 = rstatus!= 32'b0;
	  and andbcb(bexTaken, i22, bexTaken1);
	  
	 //bex for line 2 
	  wire [31:0] rstatus2 = dataA2; //bypassing needs to be added
	  wire  bexTaken2;
	  wire bexTaken12;
	  assign bexTaken12 = rstatus2!= 32'b0;
	  and andbcb2(bexTaken2, in22, bexTaken12);
	  
	  //assign bexTaken1 = (rstatus==32'b0) ? 1'b0 : 1'b1;
	 // and andBexT(bexTaken, bexTaken1, output_DX[149]);
	 
	 //JR for line 1
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
	  tristate_buffer tbj1(data_writeReg_a,   enJ1, rdReg);
	  tristate_buffer tbj2(output_XM[31:00], enJ2, rdReg);
	  wire [31:0] out;
	  
	  //PC_register  rrrd(clock, 1'b1, reset, out, rdReg);
	  PC_register  rrd(~clock, 1'b1, reset, RDREG, rdReg);
	  
	  
	  //JR for line 2
	  wire [31:0] rdReg2 = dataA2; //add bypassing later
	  
	 /** Flush logic **/
	 
	 and andFlush(FD_flush1, branchTaken, immediateX!=32'd0); //flush for branch taken
	 and andFlush2(FD_flush2, ctrl_pcTarget, target!=outputFD[63:32]); //flush for jumps to new target
	 and andFlush3(FD_flush3, bexTaken, target!=outputFD[63:32]);    //flush for bex taken
	 and andFLush4(FD_flush4, i4, rdReg!=outputFD[63:32]);  // flush for JR
	 or   orFlush(FD_flush, FD_flush1, FD_flush2, FD_flush3, FD_flush4);  //if any flush is on FLUSH
	 
	 /** Calculation of PCSrc that determines which input will be taken for nextPC **/
	 wire [1:0] pcSource, pcSource2, pcSource3, pcSource4;

	 assign pcSource = branchTaken ? 2'b1: 2'b0; //for branches mux select is one
	 assign pcSource2 = ctrl_pcTarget ? 2'd2 : pcSource; // for target jumps mux select is 2, JAL, JP
	 assign pcSource3 = bexTaken ? 2'd2 : pcSource2;
	 wire jri4;
	 or i44(jri4, i4, output_DX[150]);
	 assign pcSource4 = i4 ?  2'd3 : pcSource3; //JR assigns 3
	 
	 //if older instruction is jumping to new target we do not care what the newer one is doing
	 //unless the order is jumping to the newer, wierd case
	 //if the newer instruction is jumping then the older should not be flushed
	 
	 wire [1:0] pcSourceIn2, pcSource2In2, pcSource3In2, pcSource4In2; 
	 assign pcSourceIn2 = branchTaken ? 2'b1: 2'b0;
	 assign pcSource2In2 = ctrl_pcTarget2 ? 2'd2 : pcSourceIn2;
	 assign pcSource3In2 = bexTaken2 ? 2'd2 : pcSource2In2;
	 assign pcSource4In2 = in4 ?  2'd3 : pcSource3In2; //JR assigns 3
	 
	 //if the PCSrc from older instruction is zero meaning no jumps, take the pcSrc from newer one
	// if newer one is also zero then NextPC is chosen
	 wire [1:0] PCSrc1;
	 assign PCSrc1 = pcSource4==2'b0 ? pcSource4In2 : pcSource4;
	 
    dffe_ref df(PCSrc[0], PCSrc1[0], ~clock, 1'b1, reset);
	 dffe_ref df1(PCSrc[1], PCSrc1[1], ~clock, 1'b1, reset);
	 
	 //Line 1
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
	 assign rdest1 = JAL ? 5'd31 :5'd30; //JAL writes to register 31
	 or ordest(orD, JAL, setx); //setx write to reg 30
	 assign rdest = orD ? rdest1 :rd; //if setx or Jal take rd in DX latch to be rdest1, else normal rd
	 
	 assign rsource = orD ? 5'b0 : rs; //JAL and setx are not reading any registers
	 assign immed1 = JAL ? outputFD[63:32] : set; //if it is JAL immediate should be PC+1 bc jal writes that to reg31
	 assign immed = orD ? immed1 : immediateX;
	 wire aluZero;
	 or orALUzero(aluZero, i5, i3, i21, i7, i8);
	 
	 //Line 2 Signals for latch
	 wire [4:0] rdest2, rdestn, rsource2; 
	 wire [31:0] immed2, immedt;
	 wire [31:0] set2;
	 assign set2[26:0] = target2;
	 assign set2[27] = set2[26];
	 assign set2[28] = set2[26];
	 assign set2[29] = set2[26];
	 assign set2[30] = set2[26];
	 assign set2[31] = set2[26];
	 wire orD2;
	 assign rdest2 = JAL2 ? 5'd31 :5'd30; //JAL writes to register 31
	 or ordest1(orD2, JAL2, setx2); //setx write to reg 30
	 assign rdestn = orD2 ? rdest2 :rd2; //if setx or Jal take rd in DX latch to be rdest1, else normal rd
	 
	 assign rsource2 = orD2 ? 5'b0 : rs2; //JAL and setx are not reading any registers
	 assign immed2 = JAL2 ? outputFD[63:32] : set; //if it is JAL immediate should be PC+1 bc jal writes that to reg31
	 assign immedt = orD2 ? immed2 : immediateX2;
	 wire aluZero2;
	 or orALUzero1(aluZero2, in5, in3, in21, in7, in8);
	 
    /////////////////////////////////////////////////////////
	//****************** DX LATCH **********************////
	///////////////////////////////////////////////////////
	  wire [271:0] input_DX;
	  //newer instruction controls
	  assign input_DX[271] = in5;
	  assign input_DX[270] = in4;
	  assign input_DX[269] = bex2;
	  assign input_DX[268] = MemRead2;
	  assign input_DX[267] = noop2;
	  assign input_DX[266] = MemWrite2;
	  assign input_DX[265] = JAL2; 
	  assign input_DX[264] = JR2; 
	  assign input_DX[263] = aluZero2; //for selecting the alu mux opcode
	  assign input_DX[262] = regWrite2;
	  assign input_DX[261] = MemToReg2;
	  assign input_DX[260] = JP2;
	  assign input_DX[259] = branch2;
	  assign input_DX[258] = ALUSrc2;
	  assign input_DX[257:226] = dataA2;
	  assign input_DX[225:194] = dataB2;  
	  assign input_DX[193:189] = rdestn;  //this for bypassing and jump
	  assign input_DX[188:184] = rsource2; //used in bypass logic
	  assign input_DX[183:152] = immedt;
	  //older instruction controls
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
	  assign input_DX[36:32] = rsource; //used in bypass logic
	  assign input_DX[31:0] = immed;
	 
	  DX_latch DX(clock, DXWrite, reset, output_DX, input_DX);
	 
	 
	 /////////////////////////////////////////////////////////////////////////////////////////////////////
   /********************************** EXECUTE  Stage **************************************************/
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
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
	  tristate_buffer tbB2(data_writeReg_a,  enB1, ALU_dataB);
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
	  tristate_buffer tb2(data_writeReg_a,     en1, ALU_dataA);
	  tristate_buffer tb3(output_XM[31:0],   en2, ALU_dataA);
	  
	  wire data_resultRDY, data_exception;
	  
	  alu ALU(clock, ALU_dataA, ALU_dataB, ALUop, output_DX[11:7], data_result, isNotEqual, isLessThan, overflow, dataRDY, data_exception);
		  //later add mult div to your ALU
	     //include exception rstatus
	  wire dataRDY;  
	  wire [4:0] destRD = overflow ? 5'd30 : output_DX[41:37];
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
		
	 assign latch_result = overflow ? result : data_result;
	  /////////////////////////////////////////////////
	  ////////////// *** Line  2 *** /////////////////
	 ////////////////////////////////////////////////
	  
	  //instantiate ALU, pass in the opcode, have a mux that chooses btw the aluop and zero, select is addi
	  wire [31:0] ALU_data2B1;
	  wire [31:0] data_result2, ALU_dataA2, ALU_dataB2;
	  wire [4:0] ALUop2;
	  wire isNotEqual2, isLessThan2, overflow2, en20, en21, en22, en2B0, en2B1, en2B2;
	  wire [1:0] notALUin2A1, notALUin2B1;
	  
	  
	  
	  //choose second input, either imm for addi or dataB from reg file
	  assign ALU_dataB2 = output_DX[258] ? output_DX[183:152] : output_DX[225:194]; 
	  
	  //bypass tristate buffers
//	  not notalB1(notALUinB1[0], ALUinB[0]);
//	  not notalB2(notALUinB1[1], ALUinB[1]);
//	  and andalB1(enB0, notALUinB1[1], notALUinB1[0]);
//	  and andalB2(enB1, notALUinB1[1],     ALUinB[0]);
//	  and andalB3(enB2,     ALUinB[1], notALUinB1[0]);
//	  
//	  tristate_buffer tbB1(ALU_dataB1,     enB0, ALU_dataB);
//	  tristate_buffer tbB2(data_writeReg_a,  enB1, ALU_dataB);
//	  tristate_buffer tbB3(output_XM[31:0],enB2, ALU_dataB);
	  
	  
	  //either zeros for addi or regular aluopcode
	  assign ALUop2 = output_DX[263] ? 5'b0 : output_DX[158:154]; 
	  
	  //choose first inout, currently taking only from reg file, later add bypass options like example commented out
	  assign ALU_dataA2 = output_DX[257:226];
//	  
//	  not notalA1(notALUinA1[0], ALUinA[0]);
//	  not notalA2(notALUinA1[1], ALUinA[1]);
//	  and andalA1(en0, notALUinA1[1], notALUinA1[0]);
//	  and andalA2(en1, notALUinA1[1],     ALUinA[0]);
//	  and andalA3(en2,     ALUinA[1], notALUinA1[0]);
//	  
//	  tristate_buffer tb1(output_DX[105:74], en0, ALU_dataA);
//	  tristate_buffer tb2(data_writeReg_a,     en1, ALU_dataA);
//	  tristate_buffer tb3(output_XM[31:0],   en2, ALU_dataA);
	  
	  wire data_resultRDY2, data_exception2;
	  
	  alu ALU2(clock, ALU_dataA2, ALU_dataB2, ALUop2, output_DX[163:159], data_result2, isNotEqual2, isLessThan2, overflow2, dataRDY2, data_exception2);
		  //mult div not really functional and data_resultRDY and data_exceptions are signals from mult div so not as importatnt
	     //include exception rstatus
	  wire dataRDY2; 
	  
	  wire [4:0] destRD2 = overflow2 ? 5'd30 : output_DX[193:189];
	  //dffe_ref dfff(data_resultRDY, dataRDY, ~clock, 1'b1, reset);
	  wire isAddi2, notAddi2, isAdd2, isSub2;
	  not notAdi2(notAddi2, isAddi2);
	  wire zeroOp2 = (ALUop2==5'b0);
	  and alucheck2(isAddi2, output_DX[271], zeroOp);  
	  and aluCheck12(isAdd2, zeroOp2, notAddi2);
	  assign isSub2 = (ALUop2==5'b1);
	  wire [31:0] result2, latch_result2;
	 
	  
	   tristate_buffer tovf21(32'b1, isAdd2, result2);
		tristate_buffer tovf12(32'd2, isAddi2, result2);
		tristate_buffer tovf22(32'd3, isSub2, result2);
		
	 assign latch_result2 = overflow2 ? result2 : data_result2;
	  
    /////////////////////////////////////////////////////////
	//****************** XM LATCH **********************////
	///////////////////////////////////////////////////////
	   wire XM_MemWrite, XM_MemToReg, XM_regWrite,XM_JAL,XM_JR, XM_JP, XM_branch;
		wire [31:0] XM_NextJumpPc, XM_rd, XM_rs, XM_dataB;
		
		wire[157:0] input_XM;// output_XM;
		//newer instructions signals
		assign input_XM[157] = output_DX[268];//MemRead
		assign input_XM[156] = output_DX[267];// noop
		assign input_XM[155] = output_DX[266]; //MemWrite
		assign input_XM[154] = output_DX[261]; //MemToReg
		assign input_XM[153] = output_DX[262]; //regWrite
		assign input_XM[152:148] = destRD2; // rd; //rd should be choose btw rstatus and previous one
		assign input_XM[147:143] = output_DX[188:184]; //rs
		assign input_XM[142:111] = ALU_dataB2; //dataB
		assign input_XM[110:79] = latch_result2; //ALU result
		//Older instruction signals
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

	   wire [31:0] dmem_data_a;
		wire [31:0] dmem_data_b;
	  //calculation of PCSrc
	  // and andBranch(PCSrc, output_XM[0],output_XM[106]); //this will need to be extended to include jumps
	  
	  //output inputs to dmem and get the outputs -> read data save it to the latch
	  assign address_dmem_a = output_XM[11:0];
	  assign address_dmem_b = output_XM[90:79];
	  assign data_a = muxM ?  data_writeReg_a  : output_XM[31:0];
	  assign data_b = data_writeReg_b;  //add bypass later
	  assign wren_b =output_XM[155];
	  assign wren_a = output_XM[76];
	  assign dmem_data_a = q_dmem_a;
	  assign dmem_data_b = q_dmem_b;
	  
    /////////////////////////////////////////////////////////
	//****************** MW LATCH **********************////
	///////////////////////////////////////////////////////
	  wire[153:0] input_MW;// output_MW;
	  
	  
	  assign input_MW[153] = output_XM[156]; //noop
	  assign input_MW[152] = output_XM[154]; //MemToReg
	  assign input_MW[151] = output_XM[153];//regWrite
	  assign input_MW[150:146] = output_XM[152:148]; //rd
	  assign input_MW[145:141] = output_XM[147:143]; //rs
	  assign input_MW[140:109] = dmem_data_b; //data from memory
	  assign input_MW[108:77] = output_XM[110:79]; //ALU result
	  
	  assign input_MW[76] = output_XM[77]; //noop
	  assign input_MW[75] = output_XM[75]; //MemToReg
	  assign input_MW[74] = output_XM[74];//regWrite
	  assign input_MW[73:69] = output_XM[73:69]; //rd
	  assign input_MW[68:64] = output_XM[68:64]; //rs
	  assign input_MW[63:32] = dmem_data_a; //data from memory
	  assign input_MW[31:0] = output_XM[31:0]; //ALU result
	  
	  MW_latch MW(clock, 1'b1, reset, output_MW, input_MW);
	  
	 	 /////////////////////////////////////////////////////////////////////////////////////////////////////
   /********************************** WRITEBACK  Stage **************************************************/
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	 assign data_writeReg_a = output_MW[75] ? output_MW[63:32] : output_MW[31:0];
	 assign ctrl_writeEnable_a = output_MW[74];
	 assign ctrl_writeReg_a = output_MW[76] ? 5'b0 : output_MW[73:69];
	 
	 assign data_writeReg_b = output_MW[152] ? output_MW[140:109] : output_MW[108:77];
	 assign ctrl_writeEnable_b = output_MW[151];
	 assign ctrl_writeReg_b = output_MW[153] ? 5'b0 : output_MW[150:146];
	 //bypass logic
	  wire [1:0] ALUinA, ALUinB;
	  wire muxM;
     bypassLogic bpl(output_MW[74], output_XM[74], output_XM[76], output_MW[75], output_DX[36:32], output_DX[16:12],
	               output_XM[73:69], output_MW[73:69], rs, rd, ALUinA, ALUinB, muxM, muxBranchA, muxBranchB, bexMux, jrMux);
endmodule
