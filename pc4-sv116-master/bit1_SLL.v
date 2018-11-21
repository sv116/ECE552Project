module bit1_SLL(in1, out);

input [31:0] in1;
output [31:0] out;


assign out[0] = 1'b0;
genvar c;
   generate
	for(c=1; c<=31;c=c+1) begin: loop1
	
	assign out[c] = in1[c-1];
	
	end
	endgenerate


endmodule