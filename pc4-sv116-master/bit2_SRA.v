module bit2_SRA(in1, out);

input [31:0] in1;
output [31:0] out;

genvar c;
   generate
	for(c=0; c<=29;c=c+1) begin: loop1
	
	assign out[c] = in1[c+2];
	
	end
	endgenerate

assign out[30] = in1[31] ? 1'b1 : 1'b0;

assign out[31] = out[30];


endmodule