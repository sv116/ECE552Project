/*
module bpred(BHR, dataB, notEqual, lessThan);

	input [1:0] BHR;
	output notEqual, lessThan;


	wire sub;
	wire[31:0] data_out;

	CLA_32bit subtract(dataA, dataB, 1'b1, data_out, sub);
	
	notEqual ne(data_out, sub, notEqual);
	
	LessThan LT(dataA[31], dataB[31], data_out[31], notEqual, lessThan);

endmodule
*/
/*
module bpred();

	reg [1:0] BHR = 2'b0;
	// 00, 01, 10, 11 = saves two level branch history
	// BHT has 4 entries - each of which stores a two bit saturating counter
	reg [1:0] BHT [0:3];
	always
		begin
			//{BHT[0], BHT[1], BHT[2], BHT[3]} = 8'b0;
			BHT[BHR] = 2'b0;
		end	
endmodule
*/

module bpred(
	input [1:0] sat_counter_2bit, 	// receives BPT[BHR] = 0-3 (2'b)
	output wire predictTaken);			// outputs true/false 0-1 = false, 2-3 = true
	
	wire notTaken;
	or branch_nN(notTaken, (sat_counter_2bit == 1'd0), (sat_counter_2bit == 1'd1));
	assign predictTaken = notTaken ? 1'b0 : 1'b1;
	
endmodule
