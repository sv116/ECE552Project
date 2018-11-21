module CLA_8bit(dataA, dataB, cin, sum, G, P);

input [7:0] dataA, dataB;
input cin;

output [7:0] sum;
output G, P;

wire g0,g1, g2, g3, g4, g5,g6, g7;
wire p0, p1, p2, p3, p4, p5, p6, p7;
wire ghl1, ghl2, ghl3, ghl4, ghl5, ghl6;
wire phl1, phl2, phl3, phl4, phl5, phl6;
wire c1, c2, c3, c4, c5, c6, c7;

//1 bit adders
adder_1bit a0(dataA[0], dataB[0], cin, sum[0], g0, p0);
adder_1bit a1(dataA[1], dataB[1], c1, sum[1], g1, p1);

adder_1bit a2(dataA[2], dataB[2], c2, sum[2], g2, p2);
adder_1bit a3(dataA[3], dataB[3], c3, sum[3], g3, p3);

adder_1bit a4(dataA[4], dataB[4], c4, sum[4], g4, p4);
adder_1bit a5(dataA[5], dataB[5], c5, sum[5], g5, p5);

adder_1bit a6(dataA[6], dataB[6], c6, sum[6], g6, p6);
adder_1bit a7(dataA[7], dataB[7], c7, sum[7], g7, p7);

gp gp1(g1, p1, g0, p0, cin, c1, ghl1, phl1);
gp gp2(g3, p3, g2, p2, c2, c3, ghl2, phl2);
gp gp3(ghl2, phl2, ghl1, phl1, cin, c2, ghl3, phl3);
gp gp4(g5, p5, g4, p4, c4, c5, ghl4, phl4);
gp gp5(g7, p7, g6, p6, c6, c7, ghl5, phl5);
gp gp6(ghl5, phl5, ghl4, phl4, c4, c6, ghl6, phl6);
gp gp7(ghl6, phl6, ghl3, phl3, cin, c4, G, P);


endmodule