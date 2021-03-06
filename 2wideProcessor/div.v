module div(input1, input2, ctrl_MULT, ctrl_DIV, clock, data_result,
           data_exception, data_resultRDY);
			  
input [31:0] input1, input2;
input ctrl_MULT, clock, ctrl_DIV;
wire [31:0] data_operandA, data_operandB;
wire [31:0] A, B;
twosComplement c1(input1, A);
twosComplement c2(input2, B);
assign data_operandA = input1[31] ? A : input1;
assign data_operandB = input2[31] ? B : input2; 
 
output [31:0] data_result;
output data_exception, data_resultRDY;			  
			  
wire [31:0] initial_result = 32'd0; //quotient
wire [31:0] result_out;
wire [63:0] initial_value;
wire [63:0] current_value;
wire [31:0] current_result;
wire [63:0] partial;
wire [31:0] partial_result;
wire [31:0] divisor;
wire [63:0] data_out; //out of remainder register
wire [63:0] curr;


//setting initial value for remainder			  
assign initial_value[31:0] = data_operandA;
assign initial_value[63:32] = 32'd0;

  //for now write enable on
	 wire write_enable=1'b1;
	 
	 //reset is off, only goes on if div on and counter not equal zero or 33
	 wire reset =1'b0;
	 wire reset_c;
	 wire reset_counter;
	 //counter 32 bits shifting left until most significant bit is one
	 wire [32:0] counter;
	 wire overflow;
    assign reset_counter = reset_c ? 1'b1 : ctrl_MULT;
	 counter c(clock, write_enable, ctrl_DIV, reset_counter, counter);
	 //choosing the remainder value
	 assign current_value = counter[0] ? initial_value : partial;
	 assign current_result = counter[0] ? initial_result : partial_result;
	 
	 register1 quotient(clock, write_enable, reset, current_result, result_out);
	 register1 divi(clock, write_enable, reset, data_operandB, divisor);
	 //step 1
	 bit1_SLL64  left(current_value, curr);
	 remainderReg rem(clock, write_enable, reset, curr, data_out); 
	 
	 //step 2
	 div_calc division(divisor, data_out, result_out, partial_result, partial);		  
			  	  
	
    wire readyD;
	 assign readyD = counter[32] ? 1'b1 :1'b0;
    assign data_resultRDY = data_exception ? 1'b1 : readyD;
	 //result checking if it needs to be negative or positive
	 wire r;
	 wire r1;
	 xor xorgate(r, input1[31], input2[31]);
	 
	 wire [31:0] complement2data_result;
	 twosComplement com(partial_result, complement2data_result);
	 
	 wire notdata31;
	 not n(notdata31, partial_result[31]);
	 and a1(r1, r, notdata31); 
	 wire [31:0] flipResult;
	 assign flipResult = r1 ? complement2data_result : partial_result;
	 assign data_result = counter[32] ? flipResult : 32'd0; //only outputs correctly at the end
	 
	 //checking if operandB is zero
	 wire [31:0] notB;
	 
	 bitwiseNOT n0(data_operandB, notB);
	 bitwise1inAND a(notB, data_exception);
	 assign reset_c = data_exception ? 1'b1: 1'b0;		  
			  
			  
			  
			  
endmodule	  