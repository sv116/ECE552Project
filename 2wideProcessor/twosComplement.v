module twosComplement(data_in, data_out);

input [31:0] data_in;
output [31:0] data_out;
wire [31:0] w;
wire [31:0] w1 = 32'd1;
wire c_out;

bitwiseNOT bw(data_in, w);
CLA_32bit add(w, w1, 1'b0, data_out, c_out);

endmodule