module of_calc(a, b, in3, out);

input a, b, in3;
output out;

wire out1, out2, out3, out4, out5, out6, a_not, b_not, in3_not;

not not_a(a_not, a);
not not_b(b_not, b);
not not_3(in3_not, in3);


and and1(out1, a, b);
and and2(out2, out1, in3); // if a and b is one and in3 is one = overflow

xor xor1(out3, a, b);  // a or b 1 and 0 on output
and and3(out4, out3, in3_not);

and and4(out5, a_not, b_not); // a and b = 0 and out is 1
and and5(out6, out5, in3);


or bigOR(out, out2, out4, out6);


endmodule