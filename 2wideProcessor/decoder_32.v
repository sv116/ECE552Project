module decoder_32(ctrl_writeEnable, out_write);
//ctrl_writeEnable is ctrl_writeReg in regfile

input [4:0] ctrl_writeEnable;
output [31:0] out_write;

wire w0, w1, w2, w3, w4;

not not_0(w0, ctrl_writeEnable[0]);
not not_1(w1, ctrl_writeEnable[1]);
not not_2(w2, ctrl_writeEnable[2]);
not not_3(w3, ctrl_writeEnable[3]);
not not_4(w4, ctrl_writeEnable[4]);

assign out_write[0] = 1'b0;
and and_1(out_write[1], ctrl_writeEnable[0], w1, w2, w3, w4);
and and_2(out_write[2], w0, ctrl_writeEnable[1], w2, w3, w4);
and and_3(out_write[3], ctrl_writeEnable[0], ctrl_writeEnable[1], w2, w3, w4);
and and_4(out_write[4], w0, w1, ctrl_writeEnable[2], w3, w4);
and and_5(out_write[5], ctrl_writeEnable[0], w1, ctrl_writeEnable[2], w3, w4);
and and_6(out_write[6], w0, ctrl_writeEnable[1], ctrl_writeEnable[2], w3, w4);
and and_7(out_write[7], ctrl_writeEnable[0], ctrl_writeEnable[1], ctrl_writeEnable[2], w3, w4);
and and_8(out_write[8], w0, w1, w2, ctrl_writeEnable[3], w4);
and and_9(out_write[9], ctrl_writeEnable[0], w1, w2, ctrl_writeEnable[3], w4);
and and_10(out_write[10], w0, ctrl_writeEnable[1], w2, ctrl_writeEnable[3], w4);
and and_11(out_write[11], ctrl_writeEnable[0], ctrl_writeEnable[1], w2, ctrl_writeEnable[3], w4);
and and_12(out_write[12], w0, w1, ctrl_writeEnable[2], ctrl_writeEnable[3], w4);
and and_13(out_write[13], ctrl_writeEnable[0], w1, ctrl_writeEnable[2], ctrl_writeEnable[3], w4);
and and_gate(out_write[14], w0, ctrl_writeEnable[1], ctrl_writeEnable[2], ctrl_writeEnable[3], w4);
and and_15(out_write[15], ctrl_writeEnable[0], ctrl_writeEnable[1], ctrl_writeEnable[2], ctrl_writeEnable[3], w4);
and and_16(out_write[16], w0, w1, w2, w3, ctrl_writeEnable[4]);
and and_17(out_write[17], ctrl_writeEnable[0], w1, w2, w3, ctrl_writeEnable[4]);
and and_18(out_write[18], w0, ctrl_writeEnable[1], w2, w3, ctrl_writeEnable[4]);
and and_19(out_write[19], ctrl_writeEnable[0], ctrl_writeEnable[1], w2, w3, ctrl_writeEnable[4]);
and and_20(out_write[20], w0, w1, ctrl_writeEnable[2], w3, ctrl_writeEnable[4]);
and and_21(out_write[21], ctrl_writeEnable[0], w1, ctrl_writeEnable[2], w3, ctrl_writeEnable[4]);
and and_22(out_write[22], w0, ctrl_writeEnable[1], ctrl_writeEnable[2], w3, ctrl_writeEnable[4]);
and and_23(out_write[23], ctrl_writeEnable[0], ctrl_writeEnable[1], ctrl_writeEnable[2], w3, ctrl_writeEnable[4]);
and and_24(out_write[24], w0, w1, w2, ctrl_writeEnable[3], ctrl_writeEnable[4]);
and and_25(out_write[25], ctrl_writeEnable[0], w1, w2, ctrl_writeEnable[3], ctrl_writeEnable[4]);
and and_26(out_write[26], w0, ctrl_writeEnable[1], w2, ctrl_writeEnable[3], ctrl_writeEnable[4]);
and and_27(out_write[27], ctrl_writeEnable[0], ctrl_writeEnable[1], w2, ctrl_writeEnable[3], ctrl_writeEnable[4]);
and and_28(out_write[28], w0, w1, ctrl_writeEnable[2], ctrl_writeEnable[3], ctrl_writeEnable[4]);
and and_29(out_write[29], ctrl_writeEnable[0], w1, ctrl_writeEnable[2], ctrl_writeEnable[3], ctrl_writeEnable[4]);
and and_30(out_write[30], w0, ctrl_writeEnable[1], ctrl_writeEnable[2], ctrl_writeEnable[3], ctrl_writeEnable[4]);
and and_31(out_write[31], ctrl_writeEnable[0], ctrl_writeEnable[1], ctrl_writeEnable[2], ctrl_writeEnable[3], ctrl_writeEnable[4]);


endmodule