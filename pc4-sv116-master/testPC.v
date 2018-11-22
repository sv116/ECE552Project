module testPC(clock, jumpValue, branch, imPC, thisPC, nextPC);

   input jumpValue, branch, clock;
	input [31:0] imPC;
	output [31:0] thisPC, nextPC;

//initialize PC
	 wire PCSrc;
	// wire [31:0] nextJumpPC; //you could directly save it into latch input
	 wire [31:0]  NextPC; //thisPC,
	  
    //chose input into the pc
	 assign nextPC = PCSrc ? imPC: NextPC;
	 PC_register pc(clock, 1'b1, 1'b0, thisPC, nextPC);
	 wire [31:0] currentPC = thisPC;
	 //calculate nextPC
	 wire of;
	 wire [31:0] im1 = 32'b1;
	 CLA_32bit addPC(currentPC, im1, 1'b0, NextPC, of);
	 //get the instruction from imem	
	// assign address_imem = currentPC[11:0];
	// wire [31:0] instruction = q_imem;
	 and andBranch(PCSrc, jumpValue,branch); 
endmodule