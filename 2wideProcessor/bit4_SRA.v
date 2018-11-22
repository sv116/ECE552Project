module bit4_SRA(in1, out);

input [31:0] in1;
output [31:0] out;

genvar c;
   generate
	for(c=0; c<=27;c=c+1) begin: loop1
	
	assign out[c] = in1[c+4];
	
	end
	endgenerate

assign out[28] = in1[31] ? 1'b1 : 1'b0;

assign out[29] = out[28];
assign out[30] = out[28];
assign out[31] = out[28];
endmodule