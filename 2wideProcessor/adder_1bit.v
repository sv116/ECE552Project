module adder_1bit(in1, in2, cin, sum, G, P);

input in1, in2, cin;
output sum, P, G;


and and1(G, in1, in2);
xor xor1(P, in1, in2);
xor xor2(sum, cin, P);


endmodule