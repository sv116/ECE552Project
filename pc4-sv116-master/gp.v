module gp(Gh, Ph, Gl, Pl, cin, Ch, Ghl, Phl);

input Gh, Ph, Gl, Pl, cin;
output Ch, Ghl, Phl;

wire w1, w2;
and and1(w1, Ph, Gl);
or or1(Ghl, Gh, w1);

and and2(w2, Pl, cin);
or or2(Ch, Gl, w2);
and and3(Phl, Ph, Pl);


endmodule