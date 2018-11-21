module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	 
	 wire enable = 1'b1;
	 wire clr =1'b0;
	 wire ctrlMorD,mult;
	 or or1(ctrlMorD, ctrl_MULT, ctrl_DIV);
	 dffe_ref d1(mult, ctrl_MULT, clock, ctrl_MULT, clr);
    
	 
	
	wire data_exception1, data_exception2, data_resultRDY1, data_resultRDY2;
	wire [31:0] data_result1, data_result2;
	
 mult multiplier(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result1, data_exception1, data_resultRDY1);
 div divider(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result2, data_exception2, data_resultRDY2);

  assign data_result = mult ? data_result1 : data_result2;
  assign data_exception = mult ? data_exception1 : data_exception2;
  assign data_resultRDY = mult ? data_resultRDY1 : data_resultRDY2;
 endmodule
