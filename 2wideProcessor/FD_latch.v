module FD_latch(clock,
                ctrl_writeEnable, ctrl_writeEnable2,
                ctrl_reset, data_out, data_in);
		
 input clock, ctrl_writeEnable, ctrl_writeEnable2, ctrl_reset;		
 input [95:0] data_in;
 output [95:0] data_out;
 wire en = ctrl_writeEnable ? ctrl_writeEnable2 : 1'b0;
 genvar c;
 generate
 
 for(c=0; c<=65; c=c+1) begin: loop1
 dffe_ref f(data_out[c], data_in[c], clock, ctrl_writeEnable, ctrl_reset);
 end
 
 endgenerate
 
 genvar k;
 generate
 
 for(k=66; k<=95; k=k+1) begin: loop2
 dffe_ref f(data_out[k], data_in[k], clock, en, ctrl_reset);
 end
 
 endgenerate
endmodule