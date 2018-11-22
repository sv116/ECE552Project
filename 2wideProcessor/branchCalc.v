module branchCalc(dataA, dataB, notEqual, lessThan);

input [31:0] dataA, dataB;
output notEqual, lessThan;


wire sub;
wire[31:0] data_out;

CLA_32bit subtract(dataA, dataB, 1'b1, data_out, sub);

notEqual ne(data_out, sub, notEqual);

LessThan LT(dataA[31], dataB[31], data_out[31], notEqual, lessThan);

endmodule