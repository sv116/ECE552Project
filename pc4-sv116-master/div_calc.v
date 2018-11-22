module div_calc(divisor, remainder_in, quotient_in, quotient_out, remainder_out);

/*need to  Subtract the Divisor register from the
left half of the Remainder register, & place the
result in the left half of the Remainder register.*/


input [31:0] divisor;
input [63:0] remainder_in;
input [31:0] quotient_in;
output [31:0] quotient_out;
output [63:0] remainder_out;

wire [31:0] tempQ;
wire [63:0] subs;
assign subs[31:0] = remainder_in[31:0];

wire c_out2;
wire [31:0] not_divisor;
bitwiseNOT notDiv(divisor, not_divisor);

CLA_32bit sub(remainder_in[63:32], not_divisor, 1'b1, subs[63:32], c_out2);

assign remainder_out = subs[63] ? remainder_in : subs ;

bit1_SLL shiftQ(quotient_in, tempQ);

assign quotient_out[0] = subs[63] ? 1'b0 : 1'b1;
assign quotient_out[31:1] = tempQ[31:1];
endmodule