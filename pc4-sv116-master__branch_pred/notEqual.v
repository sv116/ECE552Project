module notEqual(sub, of, out);

input [31:0] sub;
input of;
output out;

or or1(out, sub[31], sub[30], sub[29], sub[28], sub[27], sub[26], sub[25], sub[24], sub[23],
       sub[22], sub[21], sub[20], sub[19], sub[18], sub[17], sub[16], sub[15], sub[14], sub[13],
		 sub[12], sub[11], sub[10], sub[9], sub[8], sub[7], sub[6], sub[5], sub[4], sub[3], sub[2],
		 sub[1], sub[0]);


endmodule
