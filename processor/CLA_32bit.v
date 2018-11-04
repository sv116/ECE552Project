module CLA_32bit(dataA, dataB, c_in, sum, c_out);

input [31:0] dataA, dataB;
input c_in;
output [31:0] sum;
output c_out;

wire g1, p1, g2, p2, g3, p3, g4, p4;
wire w1, w2, w3, w4, c_in1, c_in2, c_in3;

CLA_8bit adder1(dataA[7:0], dataB[7:0], c_in, sum[7:0], g1, p1);     //(dataA, dataB, cin, sum, G, P);

and and1(w1, c_in, p1);
or or1(c_in1, g1, w1);

CLA_8bit adder2(dataA[15:8], dataB[15:8], c_in1, sum[15:8], g2, p2);

and and2(w2, c_in1, p2);
or or2(c_in2, g2, w2);

CLA_8bit adder3(dataA[23:16], dataB[23:16], c_in2, sum[23:16], g3, p3);

and and3(w3, c_in2, p3);
or or3(c_in3, g3, w3);

CLA_8bit adder4(dataA[31:24], dataB[31:24], c_in3, sum[31:24], g4, p4);

and and4(w4, c_in3, p4);
or or4(c_out, g4, w4);

endmodule