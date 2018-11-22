module bit16_SRA(in1, out);

input [31:0] in1;
output [31:0] out;

genvar c;
   generate
	for(c=0; c<=15;c=c+1) begin: loop1
	
	assign out[c] = in1[c+16];
	
	end
	endgenerate

assign out[16] = in1[31] ? 1'b1 : 1'b0;

genvar a;
   generate
	for(a=17; a<=31;a=a+1) begin: loop2
	
	assign out[a] = out[16];
	
	end
	endgenerate

//assign out[17] = out[16];
//assign out[18] = out[16];
//assign out[19] = out[16];
//assign out[20] = out[16];
//assign out[21] = out[16];
//assign out[22] = out[16];
//assign out[23] = out[16];
//assign out[24] = out[16];
//assign out[25] = out[16];
//assign out[26] = out[16];
//assign out[27] = out[16];
//assign out[28] = out[16];
//assign out[29] = out[16];
//assign out[30] = out[16];
//assign out[31] = out[16];
endmodule