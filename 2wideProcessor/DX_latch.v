module DX_latch(clock,
                ctrl_writeEnable,
                ctrl_reset, data_out, data_in);
		
 input clock, ctrl_writeEnable, ctrl_reset;		
 input [271:0] data_in;
  output [271:0] data_out;
 //data in components
 /* 
     nextPC 32
	  dataA and DataB read from register file 64bits
     	  
	  opcode 5 bits
	  rd   5 bits
	  rs   5 bits
	  extended immediate 32bits
	  target = rd.rs.immediate [26:0]?
 
 */

 
 genvar c;
 
 generate
 
 for(c=0; c<=271; c=c+1) begin: loop1
 dffe_ref f(data_out[c], data_in[c], clock, ctrl_writeEnable, ctrl_reset);
 end
 
 endgenerate
 
endmodule