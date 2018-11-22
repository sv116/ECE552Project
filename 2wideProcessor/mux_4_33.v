module mux_4_33(w_0, w_1, w_2,w_3, f, s0, s1);
//Building 4x1 mux

input [32:0] w_0, w_1, w_2, w_3;
input s0,s1;
output [32:0] f;
 wire [32:0] ternary_output_0, ternary_output_1;
 
assign ternary_output_0 = s0 ? w_1 : w_0;
assign ternary_output_1 = s0 ? w_3 : w_2;
assign f = s1 ? ternary_output_1  : ternary_output_0;

endmodule