module alu(clock, data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow, 
           data_resultRDY, data_exception);
   input clock;
   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow, data_resultRDY, data_exception;
   
	wire [31:0] sra, sll, bitAnd, bitOr, sum, subs, f1, f2, data_operandBnot;
	wire c_out, c, c_of, andof, equal;
  
	//adder
	CLA_32bit  adder(data_operandA, data_operandB, 1'b0, sum, c_out); //00000
	
	//subtracting
	bitwiseNOT bNot(data_operandB, data_operandBnot);
	CLA_32bit subt(data_operandA, data_operandBnot, 1'b1, subs, c);	//00001
	
	//shift right arhitmetic
	barrel b_SRA(data_operandA, 1'b0, ctrl_shiftamt, sra);             //00101
	
	//shift left logical
	barrel b_SLL(data_operandA, 1'b1, ctrl_shiftamt, sll);             //00100
	
	//bitwise and
	bitwiseAND bitand(data_operandA, data_operandB, bitAnd);           //00010
	
	//bitwise or
	bitwiseOR bitor(data_operandA, data_operandB, bitOr);              //00011
	
	
	//not equal
	notEqual nE(subs, c, isNotEqual);

	//less than
	LessThan ls(data_operandA[31], data_operandB[31], subs[31],isNotEqual, isLessThan);
	//and andOF(andof, isNotEqual, c);
	
	//mult/div
	wire ctrl_MULT, ctrl_DIV, data_exception;
	wire [31:0] multdiv_result;
	assign ctrl_MULT = (ctrl_ALUopcode==5'd6) ? 1'b1 :1'b0;
	assign ctrl_DIV  = (ctrl_ALUopcode==5'd7) ? 1'b1 :1'b0;
	multdiv md(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, ~clock, multdiv_result, data_exception, data_resultRDY);
	
	wire overflow1, overflow2, flow;
	wire [31:0] part;
	overflowCalc oCalc(c_out, data_operandA[31], data_operandB[31], overflow1);
	CLA_32bit  adOF(data_operandBnot, 32'b1, 1'b0, part, flow);
	overflowCalc oCalSub(c, data_operandA[31], part[31], overflow2);
	
	assign overflow = ctrl_ALUopcode[0] ? overflow1: overflow2;
	
	
	//ALU mux logic
	wire [31:0] a, b; 

	mux_4 upper(sum, subs, bitAnd, bitOr, f1, ctrl_ALUopcode[0], ctrl_ALUopcode[1]);
	mux_4 lower(sll, sra, multdiv_result, multdiv_result, f2, ctrl_ALUopcode[0], ctrl_ALUopcode[1]);
	assign data_result = ctrl_ALUopcode[2] ? f2 : f1;
	

endmodule
