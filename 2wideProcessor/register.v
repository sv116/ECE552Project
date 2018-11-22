module register(
      clock,
      ctrl_writeEnable,
      ctrl_reset, data_out, data_in);
		
 input clock, ctrl_writeEnable, ctrl_reset;		
 input [31:0] data_in;
 output [31:0] data_out;
 
 genvar c;
 
 generate
 for(c=0; c<=31; c=c+1) begin: loop1
 dffe_ref f(data_out[c], data_in[c], clock, ctrl_writeEnable, ctrl_reset);
 end
 endgenerate
 
 /*
 dffe_ref f_0(data_out[0], data_in[0], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_1(data_out[1], data_in[1], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_2(data_out[2], data_in[2], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_3(data_out[3], data_in[3], clock,ctrl_writeEnable, ctrl_reset);
 dffe_ref f_4(data_out[4], data_in[4], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_5(data_out[5], data_in[5], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_6(data_out[6], data_in[6], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_7(data_out[7], data_in[7], clock,ctrl_writeEnable, ctrl_reset);	     		 
 dffe_ref f_8(data_out[8], data_in[8], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_9(data_out[9], data_in[9], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_10(data_out[10], data_in[10], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_11(data_out[11], data_in[11], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_12(data_out[12], data_in[12], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_13(data_out[13], data_in[13], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_14(data_out[14], data_in[14], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_15(data_out[15], data_in[15], clock,ctrl_writeEnable, ctrl_reset);
 dffe_ref f_16(data_out[16], data_in[16], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_17(data_out[17], data_in[17], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_18(data_out[18], data_in[18], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_19(data_out[19], data_in[19], clock,ctrl_writeEnable, ctrl_reset);	     		 
 dffe_ref f_20(data_out[20], data_in[20], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_21(data_out[21], data_in[21], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_22(data_out[22], data_in[22], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_23(data_out[23], data_in[23], clock,ctrl_writeEnable, ctrl_reset);	 
 dffe_ref f_24(data_out[24], data_in[24], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_25(data_out[25], data_in[25], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_26(data_out[26], data_in[26], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_27(data_out[27], data_in[27], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_28(data_out[28], data_in[28], clock,ctrl_writeEnable, ctrl_reset);
 dffe_ref f_29(data_out[29], data_in[29], clock,ctrl_writeEnable, ctrl_reset); 
 dffe_ref f_30(data_out[30], data_in[30], clock,ctrl_writeEnable, ctrl_reset);	
 dffe_ref f_31(data_out[31], data_in[31], clock,ctrl_writeEnable, ctrl_reset); 
 	*/		 			 
			 
endmodule			 