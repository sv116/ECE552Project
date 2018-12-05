/**
 * update_pred.v:
 * Module to update the prediction when branch result is known in the decode stage
 * **
 * Prediction - two bit saturating counter
 * 0 - strongly not taken
 * 1 - weakly not taken
 * 2 - weakly taken
 * 3 - strongly taken
 * **
 * Inputs: 
 * counter_ip - BPT[BHR] which contains the two bit prediction to update
 * branchResult - result of the branch that determines the new prediction
 * **
 * Outputs:
 * updated_counter - returns the updated prediction
 * **
 */
module update_pred(
	input [1:0] counter_ip,					// receives BPT[BHR] = 0-3 (2'b)
	input branchResult,						// actual result of branch = taken/not taken as true or false
	output wire [1:0] updated_counter
	);	//	inc if taken, dec if not taken, within the range 0-3
	
	wire inc;
	wire dec;
	wire [1:0] update;
	
	// wire inc, dec;
	and b_increment(inc, branchResult, (counter_ip != 2'b11)); // if branch taken and counter not saturated, inc
	and b_decrement(dec, (branchResult ? 1'b0 : 1'b1), (counter_ip != 2'b00));	// if branch not taken and counternot 0, dec
	
	//wire [1:0] update;
	wire saturated_counter;
	and b_update_counter(saturated_counter, !inc, !dec);
	assign update = inc ? counter_ip + 1'd1 : counter_ip - 1'd1;
	assign updated_counter = saturated_counter ? counter_ip : update;
	
endmodule
