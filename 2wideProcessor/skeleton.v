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

module skeleton(clock, reset,ctrl_writeEnable, ctrl_writeReg, data_writeReg, cycles,
	 outputFD,
	 output_DX,
	 output_XM,
	 output_MW,
	 ALUSrc,  data_result, ALU_dataA, ALU_dataB, ALUop,  branchTaken, branchA, branchB, muxBranchA, muxBranchB, lessThan1 );
    input clock, reset;
	 
	  
	 output [31:0] cycles,  data_result, ALU_dataA, ALU_dataB, branchA, branchB;
	 output [63:0] outputFD;
	 output [151:0] output_DX;
	 output [78:0] output_XM;
	 output [76:0] output_MW;
	 output ALUSrc,  branchTaken, lessThan1;
    output [4:0] ALUop;
	 output [1:0] muxBranchA, muxBranchB;
    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
	 
    wire [11:0] address_imem_a;
	 wire [11:0] address_imem_b;
    wire [31:0] q_imem_a;
	 wire [31:0] q_imem_b;
	 wire	  rden_a;
    wire   rden_b;
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
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
	 
    wire [11:0] address_dmem_a;
	 wire [11:0] address_dmem_b;
    wire [31:0] data_a;
	 wire [31:0] data_b;
    wire wren_a;
	 wire wren_b;
    wire [31:0] q_dmem_a;
	 wire [31:0] q_dmem_b;
	 
    dmem my_dmem(
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
    // Instantiate your regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg;
	 wire [4:0] ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
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
		  address_dmem_a,
        data_a,                           // O: The data to write to dmem
		  data_b,
        wren_a,                           // O: Write enable for dmem
		  wren_b,
        q_dmem_a,                         // I: The data from dmem
		  q_dmem_b,

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB,                   // I: Data from port B of regfile
		  
		  cycles,
		 outputFD,
		 output_DX,
		 output_XM,
		 output_MW,
		 ALUSrc,  data_result, ALU_dataA, ALU_dataB, ALUop,
		 branchTaken, branchA, branchB,muxBranchA, muxBranchB, lessThan1
    );

 
	 
	 
endmodule
