module triStateBufferDecoder32(ctrl_read,w_0, w_1, w_2, w_3, w_4,
              w_5, w_6, w_7, w_8, w_9, w_10,
				  w_11, w_12, w_13, w_14, w_15,
				  w_16, w_17, w_18, w_19, w_20,				  
				  w_21, w_22, w_23, w_24, w_25,
				  w_26, w_27, w_28, w_29, w_30, w_31, out);

				
input [4:0] ctrl_read;
input [31:0] w_0, w_1, w_2, w_3, w_4,
              w_5, w_6, w_7, w_8, w_9, w_10,
				  w_11, w_12, w_13, w_14, w_15,
				  w_16, w_17, w_18, w_19, w_20,
				  w_21, w_22, w_23, w_24, w_25,
				  w_26, w_27, w_28, w_29, w_30, w_31;
output [31:0] out;

wire [31:0]out_write;
wire w0, w1, w2, w3, w4, w;
not not_0(w0, ctrl_read[0]);
not not_1(w1, ctrl_read[1]);
not not_2(w2, ctrl_read[2]);
not not_3(w3, ctrl_read[3]);
not not_4(w4, ctrl_read[4]);
and andg(w, w0, w1, w2, w3, w4);
decoder_32  d32(ctrl_read, out_write);	

tristate_buffer tb0(w_0, w, out);
tristate_buffer tb1(w_1, out_write[1], out);
tristate_buffer tb2(w_2, out_write[2], out);
tristate_buffer tb3(w_3, out_write[3], out);
tristate_buffer tb4(w_4, out_write[4], out);
tristate_buffer tb5(w_5, out_write[5], out);
tristate_buffer tb6(w_6, out_write[6], out);
tristate_buffer tb7(w_7, out_write[7], out);
tristate_buffer tb8(w_8, out_write[8], out);
tristate_buffer tb9(w_9, out_write[9], out);
tristate_buffer tb10(w_10, out_write[10], out);
tristate_buffer tb11(w_11, out_write[11], out);
tristate_buffer tb12(w_12, out_write[12], out);
tristate_buffer tb13(w_13, out_write[13], out);
tristate_buffer tb14(w_14, out_write[14], out);
tristate_buffer tb15(w_15, out_write[15], out);
tristate_buffer tb16(w_16, out_write[16], out);
tristate_buffer tb17(w_17, out_write[17], out);
tristate_buffer tb18(w_18, out_write[18], out);
tristate_buffer tb19(w_19, out_write[19], out);
tristate_buffer tb20(w_20, out_write[20], out);
tristate_buffer tb21(w_21, out_write[21], out);
tristate_buffer tb22(w_22, out_write[22], out);
tristate_buffer tb23(w_23, out_write[23], out);
tristate_buffer tb24(w_24, out_write[24], out);
tristate_buffer tb25(w_25, out_write[25], out);
tristate_buffer tb26(w_26, out_write[26], out);
tristate_buffer tb27(w_27, out_write[27], out);
tristate_buffer tb28(w_28, out_write[28], out);
tristate_buffer tb29(w_29, out_write[29], out);
tristate_buffer tb30(w_30, out_write[30], out);
tristate_buffer tb31(w_31, out_write[31], out);
endmodule		
				  