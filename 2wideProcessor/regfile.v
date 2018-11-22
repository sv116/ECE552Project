module regfile (
    clock,
    ctrl_writeEnable_a, ctrl_writeEnable_b,
    ctrl_reset, ctrl_writeReg_a, ctrl_writeReg_b,
    ctrl_readRegAa, ctrl_readRegBa,ctrl_readRegAb, ctrl_readRegBb, data_writeReg_a, data_writeReg_b,
    data_readRegAa, data_readRegBa, data_readRegAb, data_readRegBb
);

   input clock, ctrl_writeEnable_a, ctrl_writeEnable_b, ctrl_reset;
   input [4:0] ctrl_writeReg_a, ctrl_writeReg_b, ctrl_readRegAa, ctrl_readRegBa,ctrl_readRegAb, ctrl_readRegBb;
   input [31:0] data_writeReg_a, data_writeReg_b;

   output [31:0] data_readRegAa, data_readRegBa, data_readRegAb, data_readRegBb;
   wire [31:0] decoder_output_a, decoder_output_b;
   
   decoder_32 dcode(ctrl_writeReg_a, decoder_output_a);
	decoder_32 dcode1(ctrl_writeReg_b, decoder_output_b);
	
   wire [31:0] O [31:0];
	wire [31:0] O1 [31:0];
	genvar c;
	generate
	for(c=0; c<=31;c=c+1) begin: loop1
	wire enable1, enable2, enable;
	wire [31:0] write_reg;
	and and_enable1(enable1, ctrl_writeEnable_a, decoder_output_a[c]);
	and and_enable2(enable2, ctrl_writeEnable_b, decoder_output_b[c]);
	assign enable = enable1 ? enable1 : enable2;
	assign write_reg = enable1 ? data_writeReg_a : data_writeReg_b;
	register regi(clock, enable, ctrl_reset, O[c], write_reg);	
	end
	endgenerate
	
	
	triStateBufferDecoder32 tri_RegAa(ctrl_readRegAa, O[0], O[1], O[2], O[3], O[4], O[5], O[6], O[7], O[8], O[9], O[10], O[11],
	                O[12], O[13], O[14], O[15], O[16], O[17], O[18], O[19], O[20], O[21], O[22], O[23],
						 O[24], O[25], O[26], O[27], O[28], O[29], O[30], O[31], data_readRegAa);
						 
	triStateBufferDecoder32 tri_RegBa(ctrl_readRegBa, O[0], O[1], O[2], O[3], O[4], O[5], O[6], O[7], O[8], O[9], O[10], O[11],
	                O[12], O[13], O[14], O[15], O[16], O[17], O[18], O[19], O[20], O[21], O[22], O[23],
						 O[24], O[25], O[26], O[27], O[28], O[29], O[30], O[31], data_readRegBa);
	
   triStateBufferDecoder32 tri_RegAb(ctrl_readRegAb, O[0], O[1], O[2], O[3], O[4], O[5], O[6], O[7], O[8], O[9], O[10], O[11],
	                O[12], O[13], O[14], O[15], O[16], O[17], O[18], O[19], O[20], O[21], O[22], O[23],
						 O[24], O[25], O[26], O[27], O[28], O[29], O[30], O[31], data_readRegAb);
						 
	triStateBufferDecoder32 tri_RegBb(ctrl_readRegBb, O[0], O[1], O[2], O[3], O[4], O[5], O[6], O[7], O[8], O[9], O[10], O[11],
	                O[12], O[13], O[14], O[15], O[16], O[17], O[18], O[19], O[20], O[21], O[22], O[23],
						 O[24], O[25], O[26], O[27], O[28], O[29], O[30], O[31], data_readRegBb);
						
	
endmodule

