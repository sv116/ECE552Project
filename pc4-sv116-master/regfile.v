module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
   wire [31:0] decoder_output;
   
   decoder_32 dcode(ctrl_writeReg, decoder_output);
	
   wire [31:0] O [31:0];
	
	genvar c;
	generate
	for(c=0; c<=31;c=c+1) begin: loop1
	
	wire enable;
	and and_enable(enable, ctrl_writeEnable, decoder_output[c]);
	register regi(clock, enable, ctrl_reset, O[c], data_writeReg);
	
	end
	endgenerate
	
	triStateBufferDecoder32 tri_RegA(ctrl_readRegA, O[0], O[1], O[2], O[3], O[4], O[5], O[6], O[7], O[8], O[9], O[10], O[11],
	                O[12], O[13], O[14], O[15], O[16], O[17], O[18], O[19], O[20], O[21], O[22], O[23],
						 O[24], O[25], O[26], O[27], O[28], O[29], O[30], O[31], data_readRegA);
						 
	triStateBufferDecoder32 tri_RegB(ctrl_readRegB, O[0], O[1], O[2], O[3], O[4], O[5], O[6], O[7], O[8], O[9], O[10], O[11],
	                O[12], O[13], O[14], O[15], O[16], O[17], O[18], O[19], O[20], O[21], O[22], O[23],
						 O[24], O[25], O[26], O[27], O[28], O[29], O[30], O[31], data_readRegB);
						 
	
endmodule

