module bit1_SRA65(in1, out);

input [64:0] in1;
output [64:0] out;

genvar c;
   generate
	for(c=0; c<=63;c=c+1) begin: loop1
	
	assign out[c] = in1[c+1];
	
	end
	endgenerate

assign out[64] = in1[64];


endmodule