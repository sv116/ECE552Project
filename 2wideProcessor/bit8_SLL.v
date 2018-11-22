module bit8_SLL(in1, out);

input [31:0] in1;
output [31:0] out;


assign out[0] = 1'b0;
assign out[1] = 1'b0;
assign out[2] = 1'b0;
assign out[3] = 1'b0;
assign out[4] = 1'b0;
assign out[5] = 1'b0;
assign out[6] = 1'b0;
assign out[7] = 1'b0;

genvar c;
   generate
	for(c=8; c<=31;c=c+1) begin: loop1
	
	assign out[c] = in1[c-8];
	
	end
	endgenerate


endmodule