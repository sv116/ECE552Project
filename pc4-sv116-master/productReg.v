module productReg( clock,
      ctrl_writeEnable,
      ctrl_reset, data_in, data_out);
		
//inputs		
 input clock, ctrl_writeEnable, ctrl_reset;		
 input [64:0] data_in;
 output [64:0] data_out;
//64th bit, technically the 0 bit will be carry bit from previous calculation
 wire not_reset;
 not not1(not_reset, ctrl_reset);
 
 genvar b;
  generate
 for(b=0; b<=64; b=b+1) begin: loop1
 dflipflop f(data_in[b], clock, not_reset, ctrl_writeEnable, data_out[b]);
 end  
 endgenerate

 endmodule