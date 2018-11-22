module bitwise1inAND(in,out);

input [31:0] in;
wire [31:0] out1 =in;
output out;


and and_bitwise(out, out1[0], out1[1], out1[2], out1[3], out1[4], out1[5], out1[6], out1[7], out1[8],
                out1[9], out1[10], out1[11], out1[12], out1[13], out1[14], out1[15], out1[16], out1[17],
					 out1[18], out1[19], out1[20], out1[21], out1[22], out1[23], out1[24], out1[25], out1[26], 
					 out1[27], out1[28], out1[29], out1[30], out1[31]);
	

endmodule