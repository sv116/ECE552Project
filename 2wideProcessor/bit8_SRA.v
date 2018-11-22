module bit8_SRA(in1, out);

input [31:0] in1;
output [31:0] out;

genvar c;
   generate
	for(c=0; c<=23;c=c+1) begin: loop1
	
	assign out[c] = in1[c+8];
	
	end
	endgenerate

assign out[24] = in1[31] ? 1'b1 : 1'b0;

assign out[25] = out[24];
assign out[26] = out[24];
assign out[27] = out[24];
assign out[28] = out[24];
assign out[29] = out[24];
assign out[30] = out[24];
assign out[31] = out[24];
endmodule