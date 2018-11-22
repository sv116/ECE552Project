module counter(clock, ctrl_writeEnable, mult, div, data);

		input  clock, ctrl_writeEnable, mult, div;
		output [32:0] data;

		wire reset;
		or org(reset, mult, div);
		
dffe_ref f(data[0], mult, clock, ctrl_writeEnable, div);       
dffe_ref f0(data[1], data[0], clock, ctrl_writeEnable, reset);  
dffe_ref f1(data[2], data[1], clock, ctrl_writeEnable, reset);  
dffe_ref f2(data[3], data[2], clock, ctrl_writeEnable, reset);  
dffe_ref f3(data[4], data[3], clock, ctrl_writeEnable, reset);
dffe_ref f4(data[5], data[4], clock, ctrl_writeEnable, reset);  
dffe_ref f5(data[6], data[5], clock, ctrl_writeEnable, reset);	
dffe_ref f6(data[7], data[6], clock, ctrl_writeEnable, reset);  
dffe_ref f7(data[8], data[7], clock, ctrl_writeEnable, reset);
dffe_ref f8(data[9], data[8], clock, ctrl_writeEnable, reset);  
dffe_ref f9(data[10], data[9], clock, ctrl_writeEnable, reset);  
dffe_ref f10(data[11], data[10], clock, ctrl_writeEnable, reset);  
dffe_ref f11(data[12], data[11], clock, ctrl_writeEnable, reset);
dffe_ref f12(data[13], data[12], clock, ctrl_writeEnable, reset);  
dffe_ref f13(data[14], data[13], clock, ctrl_writeEnable, reset);	
dffe_ref f14(data[15], data[14], clock, ctrl_writeEnable, reset);  
dffe_ref f15(data[16], data[15], clock, ctrl_writeEnable, reset);
dffe_ref f16(data[17], data[16], clock, ctrl_writeEnable, reset);  
dffe_ref f17(data[18], data[17], clock, ctrl_writeEnable, reset);  
dffe_ref f18(data[19], data[18], clock, ctrl_writeEnable, reset);
dffe_ref f19(data[20], data[19], clock, ctrl_writeEnable, reset);  
dffe_ref f20(data[21], data[20], clock, ctrl_writeEnable, reset);	
dffe_ref f21(data[22], data[21], clock, ctrl_writeEnable, reset);  
dffe_ref f22(data[23], data[22], clock, ctrl_writeEnable, reset);		
dffe_ref f23(data[24], data[23], clock, ctrl_writeEnable, reset);	
dffe_ref f24(data[25], data[24], clock, ctrl_writeEnable, reset);  
dffe_ref f25(data[26], data[25], clock, ctrl_writeEnable, reset);	
dffe_ref f26(data[27], data[26], clock, ctrl_writeEnable, reset);	
dffe_ref f27(data[28], data[27], clock, ctrl_writeEnable, reset);  
dffe_ref f28(data[29], data[28], clock, ctrl_writeEnable, reset);
dffe_ref f29(data[30], data[29], clock, ctrl_writeEnable, reset);	
dffe_ref f30(data[31], data[30], clock, ctrl_writeEnable, reset);  
dffe_ref f31(data[32], data[31], clock, ctrl_writeEnable, reset);		


endmodule


