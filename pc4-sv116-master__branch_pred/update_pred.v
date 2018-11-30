/**
 * 
 * 
 */
module update_pred(
	input [1:0] counter_ip,					// receives BPT[BHR] = 0-3 (2'b)
	input branchResult,						// actual result of branch = taken/not taken as true or false
	output wire [1:0] updated_counter,
	output wire inc,
	output wire dec,
	output wire [1:0] update);	//	inc if taken, dec if not taken, within the range 0-3
	
	// wire inc, dec;
	and b_increment(inc, branchResult, (counter_ip != 2'b11)); // if branch taken and counter not saturated, inc
	and b_decrement(dec, (branchResult ? 1'b0 : 1'b1), (counter_ip != 2'b00));	// if branch not taken and counternot 0, dec
	
	//wire [1:0] update;
	wire bool_update_counter;
	and b_update_counter(bool_update_counter, !inc, !dec);
	assign update = inc ? counter_ip + 1'd1 : counter_ip - 1'd1;
	assign updated_counter = bool_update_counter ? counter_ip : update;
	
endmodule
