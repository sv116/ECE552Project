module bit16_SLL(in1, out);

input [31:0] in1;
output [31:0] out;

genvar a;
  generate
  for(a=0; a<=15; a=a+1)begin: loop1
  
	assign out[a] = 1'b0;
	
	end
	endgenerate

genvar c;
   generate
	for(c=16; c<=31;c=c+1) begin: loop2
	
	assign out[c] = in1[c-16];
	
	end
	endgenerate


endmodule