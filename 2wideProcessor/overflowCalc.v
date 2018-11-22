module overflowCalc(ov, a, b, overflow);
input ov, a, b;
output overflow;


wire equal, ov1, ov2, ov3, ov4, ov_not, a_not, b_not;
not not1(a_not, a);
not not2(b_not, b);
not not3(ov_not, ov);

and and1(ov1, a, b);
and and2(ov2, a_not, b_not) ;

and and3(ov3, ov_not, ov1);
and and4(ov4, ov, ov2);
or(overflow, ov3, ov4);

endmodule