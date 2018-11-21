module boothLogic(partial, data_operandA, data_out);

input [31:0] data_operandA; //multiplicand
input [64:0] partial; //partial product

output [64:0] data_out;
wire s0, s1;

assign s0 = partial[0];
assign s1 = partial[1];
wire [64:0] data;

wire [31:0] notA;
wire c_out1, c_out2;

wire [64:0] sum, subs;
assign sum[32:0] = partial[32:0];
assign subs[32:0] = partial[32:0];

bitwiseNOT nota(data_operandA, notA);
CLA_32bit adder(partial[64:33], data_operandA, 1'b0, sum[64:33], c_out1);
CLA_32bit sub(partial[64:33], notA, 1'b1, subs[64:33], c_out2);



mux_4_65 mux1(partial, sum, subs, partial, data, s0, s1);

bit1_SRA65 shift(data, data_out);


endmodule