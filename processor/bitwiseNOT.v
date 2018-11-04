module bitwiseNOT(in, out);

input [31:0] in;
output[31:0] out;

genvar a;
  generate
  for(a=0; a<=31; a=a+1)begin: loop1
  
	not notg(out[a], in[a]);
	
	end
	endgenerate



endmodule