module mux_32(ctrl_read,w_0, w_1, w_2, w_3, w_4,
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
	wire [31:0] out_m1, out_m2, out_m3, out_m4, out_m5, 
	out_m6, out_m7, out_m8, out_m9, out_m10;
	 
	mux_4 m_1(w_0, w_1, w_2, w_3, out_m1, ctrl_read[0], ctrl_read[1]);
   mux_4 m_2(w_4, w_5, w_6, w_7, out_m2, ctrl_read[0], ctrl_read[1]);
   mux_4 m_3(w_8, w_9, w_10, w_11, out_m3, ctrl_read[0], ctrl_read[1]);	
	mux_4 m_4(w_12, w_13, w_14, w_15, out_m4, ctrl_read[0], ctrl_read[1]);
   mux_4 m_5(w_16, w_17, w_18, w_19, out_m5, ctrl_read[0], ctrl_read[1]);
   mux_4 m_6(w_20, w_21, w_22, w_23, out_m6, ctrl_read[0], ctrl_read[1]);	
	mux_4 m_7(w_24, w_25, w_26, w_27, out_m7, ctrl_read[0], ctrl_read[1]);
   mux_4 m_8(w_28, w_29, w_30, w_31, out_m8, ctrl_read[0], ctrl_read[1]);	
					  			  
	mux_4 m_9(out_m1, out_m2, out_m3, out_m4, out_m9, ctrl_read[2], ctrl_read[3]);
   mux_4 m_10(out_m5, out_m6, out_m7, out_m8, out_m10, ctrl_read[2], ctrl_read[3]);	
	
	assign out = ctrl_read[4] ? out_m10 : out_m9;
					  
endmodule