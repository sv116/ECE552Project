module bit1_SRA(in1, out);

input [31:0] in1;
output [31:0] out;

genvar c;
   generate
	for(c=0; c<=30;c=c+1) begin: loop1
	
	assign out[c] = in1[c+1];
	
	end
	endgenerate

assign out[31] = in1[31] ? 1'b1 : 1'b0;


endmodule