module bit1_SLL64(in1, out);

input [63:0] in1;
output [63:0] out;


assign out[0] = 1'b0;
genvar c;
   generate
	for(c=1; c<=63;c=c+1) begin: loop1
	
	assign out[c] = in1[c-1];
	
	end
	endgenerate


endmodule