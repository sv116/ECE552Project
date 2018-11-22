module bitwiseAND(in1,in2,out);

input [31:0] in1, in2;
output [31:0] out;

   genvar c;
   generate
	for(c=0; c<=31;c=c+1) begin: loop1
	
	and and_bitwise(out[c], in1[c], in2[c]);
	
	end
	endgenerate

endmodule