/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module skeleton(clock, reset,ctrl_writeEnable_a, ctrl_writeReg_a, data_writeReg_a, cycles, q_imem_a, q_imem_b,
    address_imem_a, address_imem_b, rden_a, rden_b,
	 outputFD,
	 dx1, dx2,
	 output_XM,
	 output_MW,
	 ALUSrc,  data_result, ALU_dataA, ALU_dataB, ALUop,  branchTaken, branchA, branchB, muxBranchA, muxBranchB, lessThan1 );
    input clock, reset;
	 
	  
	 output [31:0] cycles,  data_result, ALU_dataA, ALU_dataB, branchA, branchB;
	 output [95:0] outputFD;
	 wire [271:0] output_DX;
	 output [151:0] dx1 =output_DX[151:0];
	 output [119:0] dx2 = output_DX[271:152];
	 output [78:0] output_XM;
	 output [76:0] output_MW;
	 output ALUSrc,  branchTaken, lessThan1;
    output [4:0] ALUop;
	 output [1:0] muxBranchA, muxBranchB;
    /** IMEM **/
   
    output [11:0] address_imem_a;
	 output [11:0] address_imem_b;
    output [31:0] q_imem_a;
	 output [31:0] q_imem_b;
	 output	 rden_a;
    output   rden_b;
    imem2 my_imem(
        .address_a    (address_imem_a),	 // address of data a
		  .address_b    (address_imem_b),
        .clock        (~clock),            // you may need to invert the clock
        .q_a          (q_imem_a),           // the raw instruction
		  .q_b          (q_imem_b),
		  .rden_a       (rden_a),            //read enable for a
		  .rden_b       (rden_b)
    );

    /** DMEM **/
	 
    wire [11:0] address_dmem_a;
	 wire [11:0] address_dmem_b;
    wire [31:0] data_a;
	 wire [31:0] data_b;
    wire wren_a;
	 wire wren_b;
    wire [31:0] q_dmem_a;
	 wire [31:0] q_dmem_b;
	 
    dmem2 my_dmem(
        .address_a    (address_dmem_a),       // address of data a
		  .address_b    (address_dmem_b),       // address of data b
        .clock        (~clock),                  // may need to invert the clock
        .data_a	    (data_a),    // data you want to write
		  .data_b	    (data_b),    // data you want to write
        .wren_a	    (wren_a),      // write enable
		  .wren_b	    (wren_b),      // write enable
        .q_a          (q_dmem_a),    // data from dmem
		  .q_b          (q_dmem_b)
    );

    /** REGFILE **/

    output ctrl_writeEnable_a;
	 wire ctrl_writeEnable_b;
    output [4:0] ctrl_writeReg_a;
	 wire ctrl_writeReg_b;
	 wire [4:0] ctrl_readRegAa, ctrl_readRegBa, ctrl_readRegAb, ctrl_readRegBb;
    output [31:0] data_writeReg_a;
	 wire data_writeReg_b;
    wire [31:0] data_readRegAa, data_readRegBa, data_readRegAb, data_readRegBb;
    
	 regfile my_regfile(
			 ~clock,
			 ctrl_writeEnable_a,
			 ctrl_writeEnable_b,
			 reset,
			 ctrl_writeReg_a,
			 ctrl_writeReg_b,
			 ctrl_readRegAa,
			 ctrl_readRegBa,
			 ctrl_readRegAb,
			 ctrl_readRegBb,
			 data_writeReg_a,
			 data_writeReg_b,
			 data_readRegAa,
			 data_readRegBa,
			 data_readRegAb,
			 data_readRegBb
    );

    /** PROCESSOR **/
	 
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem_a,                  // O: The address of the data to get from imem
		  address_imem_b,                  // O: The address of the data to get from imem
		  q_imem_a,                        // I: The data from imem
        q_imem_b,                        // I: The data from imem
        rden_a,                          // O: Read enable
        rden_b,		  

        // Dmem
        address_dmem_a,                  // O: The address of the data to get or put from/to dmem
		  address_dmem_b,
        data_a,                           // O: The data to write to dmem
		  data_b,
        wren_a,                           // O: Write enable for dmem
		  wren_b,
        q_dmem_a,                         // I: The data from dmem
		  q_dmem_b,

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
		 ALUSrc,  data_result, ALU_dataA, ALU_dataB, ALUop,
		 branchTaken, branchA, branchB,muxBranchA, muxBranchB, lessThan1
    );

 
	 
	 
endmodule
