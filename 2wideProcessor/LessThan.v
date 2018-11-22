module LessThan(a, b, sub, ine, out);

input a, b, sub, ine;
output out;

wire out1, out2, out3, out4, out5, out6, a_not, b_not;

not not_a(a_not, a);
not not_b(b_not, b);


and and1(out1, ine, a, b_not); //if not equal, a negative, b positive number -> lessthan on

and and2(out2, ine, a, b); //if a b both one
and and3(out3, ine, a_not, b_not) ; // if both zero

and and4(out4, out3, sub); //a<b   both zero  and sub 1
and and5(out5, out2, sub); //a<b   both a b one and sub 1

or bigOR(out6, out1, out4, out5);
assign out = out6; 

endmodule
//
//input [31:0]sub;
//input of;
//output out;
//
//wire out1, subnot, out2, out3, out4, out5, ofN;
//
//notEqual nQ(sub, of, out1);
//
//and and1(out2, out1, sub[31], of); // is less case1
//not not1(subnot, sub[31]);
//not not2(ofN, of);
//and and2(out3, out1, subnot, of);        // is less case 2
//and and3(out4, out1, subnot, ofN);     //case3
//or or1(out5, out2, out3, out4);
//not not3(out, out5);
