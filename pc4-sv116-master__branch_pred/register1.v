module register1(clock,
      ctrl_writeEnable,
      ctrl_reset, data_in, data_out);

//inputs		
 input clock, ctrl_writeEnable, ctrl_reset;		
 input [31:0] data_in;
 output[31:0] data_out;

 wire ctrln;
 not not1(ctrln, ctrl_reset);


 genvar b;
 generate
 for(b=0; b<=31; b=b+1) begin: loop1
 dflipflop f(data_in[b], clock, ctrln, ctrl_writeEnable, data_out[b]);
 end  
 endgenerate
 
 endmodule