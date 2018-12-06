module bypassLogic2 ( MW_regWrite_1, MW_regWrite_2,
							XM_regWrite_1, XM_regWrite_2,
							XM_memWrite_1, XM_memWrite_2,
							MW_MemToReg_1, MW_MemToReg_2,
							DX_rs_1, DX_rs_2,
							DX_rt_1, DX_rt_2,
							XM_rd_1, XM_rd_2,
							MW_rd_1, MW_rd_2,
							rs_1, rd_1, rs_2, rd_2, // get rd and rs from both pipes -> control hazards
                     ALUin1A, ALUin1B, ALUin2A, ALUin2B,
							muxM1, muxM2,
							muxBranchA_1, muxBranchB_1, muxBranchA_2, muxBranchB_2,
							bexMux1, bexMux2,
							jrMux1, jrMux2
							)
		;
// ex1 is left - MuxM
							
							
input MW_regWrite_1, XM_memWrite_1, MW_MemToReg_1, XM_regWrite_1,
		MW_regWrite_2, XM_memWrite_2, MW_MemToReg_2, XM_regWrite_2;
input [4:0] DX_rs_1, DX_rt_1, XM_rd_1, MW_rd_1,
				DX_rs_2, DX_rt_2, XM_rd_2, MW_rd_2,
				rs_1, rd_1, rs_2, rd_2;
	
output [2:0] ALUin1A, ALUin1B, ALUin2A, ALUin2B;
output [2:0] muxBranchA_1, muxBranchB_1, muxBranchA_2, muxBranchB_2;
output [1:0] muxM1, muxM2;
output [3:0] bexMux1, bexMux2, jrMux1, jrMux2;


//data hazards
wire mem1, mem2, ex1, ex2;
wire P_hazard1_1, P_hazard2_1, P_hazard1_2, P_hazard2_2,
	  Q_hazard1_1, Q_hazard2_1, Q_hazard1_2, Q_hazard2_2,
	  hazard3, hazard4,
	  P_hAm1_1, P_hAm2_1, P_hAm1_2, P_hA2_2,
	  Q_hAm1_1, Q_hAm2_1, Q_hAm1_2, Q_hA2_2,
	  P_hBm1_1, P_hBm2_1, P_hBm1_2, P_hBm2_2,
	  Q_hBm1_1, Q_hBm2_1, Q_hBm1_2, Q_hBm2_2;
wire [1:0] bM;

// nomenclature:
//// 1_1: from MW_1 latch  // checking MW of pipe P
//// 2_1: from XM_1 latch  
//// 1_2: from MW_2 latch  // checking MW of pipe Q
//// 2_2: from XM_2 latch
//
//// prefixed by:
//// P_ PIPE 1
//// Q_ PIPE 2


// PIPE 1 - P
wire P_mem1_1, P_mem1_2, P_mem2_1, P_mem2_2;
or P_or_1(P_hazard1_1, MW_rd_1==DX_rs_1, MW_rd_1 == DX_rt_1);
or P_or_2(P_hazard2_1, XM_rd_1==DX_rs_1, XM_rd_1 == DX_rt_1);
or P_or_3(P_hazard1_2, MW_rd_2==DX_rs_1, MW_rd_2 == DX_rt_1);
or P_or_4(P_hazard2_2, XM_rd_2==DX_rs_1, XM_rd_2 == DX_rt_1);

and P_and1_1(P_mem1_1, MW_regWrite_1, MW_rd_1 != 5'b0, P_hazard1_1); 
and P_and2_1(P_mem2_1, XM_regWrite_1, XM_rd_1 != 5'b0, P_hazard2_1);
and P_and1_2(P_mem1_2, MW_regWrite_2, MW_rd_2 != 5'b0, P_hazard1_2); 
and P_and2_2(P_mem2_2, XM_regWrite_2, XM_rd_2 != 5'b0, P_hazard2_2);


// first source (A) - pipe 1

and P_andA1_1(P_hAm1_1, MW_rd_1==DX_rs_1, P_mem1_1);
and P_andA2_1(P_hAm2_1, XM_rd_1==DX_rs_1, P_mem2_1);
and P_andA1_2(P_hAm1_2, MW_rd_2==DX_rs_1, P_mem1_2);
and P_andA2_2(P_hAm2_2, XM_rd_2==DX_rs_1, P_mem2_2);


assign ALUin1A =    P_hAm2_2 ? 3'd4 
					 : ( P_hAm1_2 ? 3'd3
					 : ( P_hAm2_1 ? 3'd2      // XM in   
					 : ( P_hAm1_1 ? 3'd1     // MW in it's own pipe
					 : 3'b0 )))             // from regfile
				;
					

//second source (B) - pipe 1
wire hBm1_1, hBm1_2, hBm2_1,hBm2_2;
and andB1_1(hBm1_1, MW_rd_1==DX_rt_1, P_mem1_1);
and andB2_1(hBm2_1, XM_rd_1==DX_rt_1, P_mem2_1);
and andB1_2(hBm1_2, MW_rd_2==DX_rt_1, P_mem1_1);
and andB2_2(hBm2_2, XM_rd_2==DX_rt_1, P_mem2_1);

assign ALUin1B =  hBm2_2 ? 3'd4 
					 : ( hBm1_2 ? 3'd3
					 : ( hBm2_1 ? 3'd2
					 : ( hBm1_1 ? 3'd1
					 : 3'b0 )))
				;
			
// pipe 2 - Q			
wire Q_mem1_1,Q_mem1_2,Q_mem1_3,Q_mem1_4;			
or Q_or_1(Q_hazard1_1, MW_rd_1==DX_rs_2, MW_rd_1 == DX_rt_2);
or Q_or_2(Q_hazard2_1, XM_rd_1==DX_rs_2, XM_rd_1 == DX_rt_2);
or Q_or_3(Q_hazard1_2, MW_rd_2==DX_rs_2, MW_rd_2 == DX_rt_2);
or Q_or_4(Q_hazard2_2, XM_rd_2==DX_rs_2, XM_rd_2 == DX_rt_2);
                                      //DX_rd1 == rs or rt DX_2 this is stall not bypass
			
and Q_and1_1(Q_mem1_1, MW_regWrite_1, MW_rd_1 != 5'b0, Q_hazard1_1); 
and Q_and2_1(Q_mem2_1, XM_regWrite_1, XM_rd_1 != 5'b0, Q_hazard2_1);
and Q_and1_2(Q_mem1_2, MW_regWrite_2, MW_rd_2 != 5'b0, Q_hazard1_2); 
and Q_and2_2(Q_mem2_2, XM_regWrite_2, XM_rd_2 != 5'b0, Q_hazard2_2);

// first source (A) - pipe 2
					 
and Q_andA1_1(Q_hAm1_1, MW_rd_1==DX_rs_2, Q_mem1_1);
and Q_andA2_1(Q_hAm2_1, XM_rd_1==DX_rs_2, Q_mem2_1);
and Q_andA1_2(Q_hAm1_2, MW_rd_2==DX_rs_2, Q_mem1_2);
and Q_andA2_2(Q_hAm2_2, XM_rd_2==DX_rs_2, Q_mem2_2);


assign ALUin2A =    Q_hAm2_2 ? 3'd4 
					 : ( Q_hAm1_2 ? 3'd3
					 : ( Q_hAm2_1 ? 3'd2
					 : ( Q_hAm1_1 ? 3'd1
					 : 3'b0 )))
				;
					
//second source (B) - pipe 2

and Q_andB1_1(Q_hBm1_1, MW_rd_1==DX_rt_2, Q_mem1_1);
and Q_andB2_1(Q_hBm2_1, XM_rd_1==DX_rt_2, Q_mem2_1);
and Q_andB1_2(Q_hBm1_2, MW_rd_2==DX_rt_2, Q_mem1_1);
and Q_andB2_2(Q_hBm2_2, XM_rd_2==DX_rt_2, Q_mem2_1);

assign ALUin2B =    Q_hBm2_2 ? 3'd4 
					 : ( Q_hBm1_2 ? 3'd3
					 : ( Q_hBm2_1 ? 3'd2
					 : ( Q_hBm1_1 ? 3'd1
					 : 3'b0 )))
				;
	
// 	

// MW2, MW1, ALU2, ALU1
/////// PIPE 1

wire P_ex1,P_ex2,Q_ex1,Q_ex2,Q_ex3,Q_ex4;
and and1(P_ex2, MW_MemToReg_1, XM_memWrite_1, MW_rd_1 != 5'b0, MW_rd_1==XM_rd_1); // writing to reg in MW1, using that value in XM1 01
and and2(P_ex1, MW_MemToReg_2, XM_memWrite_1, MW_rd_2 != 5'b0, MW_rd_2==XM_rd_1); // writing to reg i MW1, using the value from XM2 10
                                                                                                                         //** 00 ALU results
//and and3(P_ex3, MW_MemToReg_1, XM_memWrite_2, MW_rd_1 != 5'b0, MW_rd_1==XM_rd_2);
//and and4(P_ex4, MW_MemToReg_2, XM_memWrite_1, MW_rd_2 != 5'b0, MW_rd_2==XM_rd_1);



///// PIPE 2
and andQ1(Q_ex2, MW_MemToReg_1, XM_memWrite_2, MW_rd_1 != 5'b0, MW_rd_1==XM_rd_2);
and andQ2(Q_ex1, MW_MemToReg_2, XM_memWrite_2, MW_rd_2 != 5'b0, MW_rd_2==XM_rd_2);
//and andQ3(Q_ex3, MW_MemToReg_1, XM_memWrite_2, MW_rd_1 != 5'b0, MW_rd_1==XM_rd_2);
//and andQ4(Q_ex4, MW_MemToReg_2, XM_memWrite_1, MW_rd_2 != 5'b0, MW_rd_2==XM_rd_1);

assign muxM1 =  P_ex2 ? 2'd2  //from pipe 2 in MW  //none
				 : (P_ex1 ? 2'd1 //from pipe 2 of MW to pipe 2 of XM
				 : 2'd0);
assign muxM2 =  Q_ex1 ? 2'd2
				 : (Q_ex2 ? 2'd1
				 : 2'd0)
				 ;
				 

//////////////////////////////
////// control hazards ///////
//////////////////////////////

// rd and rs from both pipes -> hazard3 & 4 for both pipes

// rd_1, rs_1, rd_2, rs_2

wire c1, c2, h1, h2, h3, h4, cc1, cc2;
//wire ;.'[1:0] muxC, muxC2;

wire P_hazard3_1, P_hazard3_2, P_hazard4_1, P_hazard4_2;
wire P_c3_1, P_c3_2, P_c4_1, P_c4_2;
wire P_hA3_1, P_hA3_2, P_hA4_1, P_hA_4_2, P_hB3_1, P_hB3_2, P_hB4_1, P_hB_4_2;
wire Q_hazard3_1, Q_hazard3_2, Q_hazard4_1, Q_hazard4_2;
wire Q_c3_1, Q_c3_2, Q_c4_1, Q_c4_2;
wire Q_hA3_1, Q_hA3_2, Q_hA4_1, Q_hA_4_2, Q_hB3_1, Q_hB3_2, Q_hB4_1, Q_hB_4_2;


// PIPE 1: P

or P_or3_1(P_hazard3_1, MW_rd_1==rs_1, MW_rd_1 == rd_1);
or P_or4_1(P_hazard4_1, XM_rd_1==rs_1, XM_rd_1 == rd_1);
or P_or3_2(P_hazard3_2, MW_rd_2==rs_1, MW_rd_2 == rd_1);
or P_or4_2(P_hazard4_2, XM_rd_2==rs_1, XM_rd_2 == rd_1);

and P_andc3_1(P_c3_1, MW_regWrite_1, MW_rd_1 != 5'b0, P_hazard3_1); 
and P_andc4_1(P_c4_1, XM_regWrite_1, XM_rd_1 != 5'b0, P_hazard4_1);
and P_andc3_2(P_c3_2, MW_regWrite_2, MW_rd_1 != 5'b0, P_hazard3_2); 
and P_andc4_2(P_c4_2, XM_regWrite_2, XM_rd_1 != 5'b0, P_hazard4_2);


//01 take the reg value from MW latch
//10 ---------------         XM

// rs
and P_andA3_1(P_hA3_1, MW_rd_1==rs_1, P_c3_1);
and P_andA4_1(P_hA4_1, XM_rd_1==rs_1, P_c4_1);
and P_andA3_2(P_hA3_2, MW_rd_2==rs_1, P_c3_2);
and P_andA4_2(P_hA4_2, XM_rd_2==rs_1, P_c4_2);

assign muxBranchA_1 =    P_hA4_2 ? 3'd4 // XM of the other pipe
							: ( P_hA3_2 ? 3'd3 // MW of the pther pipe
							: ( P_hA4_1 ? 3'd2 // XM of the same pipe
							: ( P_hA3_1 ? 3'd1 // MW of the same pipe
 							: 3'b0 ))) 
						;

// rd
and P_andB3_1(P_hB3_1, MW_rd_1==rd_1, P_c3_1);
and P_andB4_1(P_hB4_1, XM_rd_1==rd_1, P_c4_1);
and P_andB3_2(P_hB3_2, MW_rd_2==rd_1, P_c3_2);
and P_andB4_2(P_hB4_2, XM_rd_2==rd_1, P_c4_2);

assign muxBranchB_1 =    P_hB4_2 ? 3'd4 
							: ( P_hB3_2 ? 3'd3
							: ( P_hB4_1 ? 3'd2
							: ( P_hB3_1 ? 3'd1
							: 3'b0 )))
						;


// PIPE 2: Q

or Q_or3_1(Q_hazard3_1, MW_rd_1==rs_2, MW_rd_1 == rd_2);
or Q_or4_1(Q_hazard4_1, XM_rd_1==rs_2, XM_rd_1 == rd_2);
or Q_or3_2(Q_hazard3_2, MW_rd_2==rs_2, MW_rd_2 == rd_2);
or Q_or4_2(Q_hazard4_2, XM_rd_2==rs_2, XM_rd_2 == rd_2);

and Q_andc3_1(Q_c3_1, MW_regWrite_1, MW_rd_2 != 5'b0, Q_hazard3_1); 
and Q_andc4_1(Q_c4_1, XM_regWrite_1, XM_rd_2 != 5'b0, Q_hazard4_1);
and Q_andc3_2(Q_c3_2, MW_regWrite_2, MW_rd_2 != 5'b0, Q_hazard3_2); 
and Q_andc4_2(Q_c4_2, XM_regWrite_2, XM_rd_2 != 5'b0, Q_hazard4_2);


// rs
and Q_andA3_1(Q_hA3_1, MW_rd_1==rs_2, Q_c3_1);
and Q_andA4_1(Q_hA4_1, XM_rd_1==rs_2, Q_c4_1);
and Q_andA3_2(Q_hA3_2, MW_rd_2==rs_2, Q_c3_2);
and Q_andA4_2(Q_hA4_2, XM_rd_2==rs_2, Q_c4_2);

assign muxBranchA_2 =    Q_hA4_2 ? 3'd4 
							: ( Q_hA3_2 ? 3'd3
							: ( Q_hA4_1 ? 3'd2
							: ( Q_hA3_1 ? 3'd1
							: 3'b0 )))
						;

// rd
and Q_andB3_1(Q_hB3_1, MW_rd_1==rd_2, Q_c3_1);
and Q_andB4_1(Q_hB4_1, XM_rd_1==rd_2, Q_c4_1);
and Q_andB3_2(Q_hB3_2, MW_rd_2==rd_2, Q_c3_2);
and Q_andB4_2(Q_hB4_2, XM_rd_2==rd_2, Q_c4_2);

assign muxBranchB_2 =    Q_hB4_2 ? 3'd4 
							: ( Q_hB3_2 ? 3'd3
							: ( Q_hB4_1 ? 3'd2
							: ( Q_hB3_1 ? 3'd1
							: 3'b0 )))
						;

						
//////////////////
/// bex hazard ///
//////////////////

wire P_b1_1, Pb1_2, P_b1_2, P_b2_2;
wire Q_b1_1, Qb1_2, Q_b1_2, Q_b2_2;

// PIPE 2 (P)

and P_andBex1_1(P_b1_1, MW_regWrite_1, MW_rd_1==5'd30);
and P_andBex2_1(P_b2_1, XM_regWrite_1, XM_rd_1==5'd30);
and P_andBex1_2(P_b1_2, MW_regWrite_1, MW_rd_2==5'd30);
and P_andBex2_2(P_b2_2, XM_regWrite_1, XM_rd_2==5'd30);

assign bexMux1 =   P_b2_2 ? 4'd8 
					: ( P_b1_2 ? 4'd4
					: ( P_b2_1 ? 4'd2
					: ( P_b1_1 ? 4'd1
					: 4'b0 )))
				;

// PIPE 2 (Q)

and Q_andBex1_1(Q_b1_1, MW_regWrite_2, MW_rd_1==5'd30);
and Q_andBex2_1(Q_b2_1, XM_regWrite_2, XM_rd_1==5'd30);
and Q_andBex1_2(Q_b1_2, MW_regWrite_2, MW_rd_2==5'd30);
and Q_andBex2_2(Q_b2_2, XM_regWrite_2, XM_rd_2==5'd30);

assign bexMux2 =   Q_b2_2 ? 4'd8 
					: ( Q_b1_2 ? 4'd4
					: ( Q_b2_1 ? 4'd2
					: ( Q_b1_1 ? 4'd1
					: 4'b0 )))
				;

			
///////////////			
// jr bypass //--- rdmux
///////////////

wire P_j1_1, P_j2_1, P_j1_2, P_j2_2;
wire Q_j1_1, Q_j2_1, Q_j1_2, Q_j2_2;
// PIPE 1 (P)

and P_andj1_1(P_j1_1, MW_regWrite_1, (MW_rd_1==rd_1), MW_rd_1 != 5'b0);
and P_andj2_1(P_j2_1, XM_regWrite_1, (XM_rd_1==rd_1), XM_rd_1 != 5'b0);
and P_andj1_2(P_j1_2, MW_regWrite_1, (MW_rd_1==rd_1), MW_rd_1 != 5'b0);
and P_andj2_2(P_j2_2, XM_regWrite_1, (XM_rd_1==rd_1), XM_rd_1 != 5'b0);

assign jrMux1 = P_j2_2 ? 4'd8 
				: ( P_j1_2 ? 4'd4
				: ( P_j2_1 ? 4'd2
				: ( P_j1_1 ? 4'd1
				: 4'b0 )))
			;

// PIPE 2 (Q)

and Q_andj1_1(Q_j1_1, MW_regWrite_2, (MW_rd_2==rd_2), MW_rd_2 != 5'b0);
and Q_andj2_1(Q_j2_1, XM_regWrite_2, (XM_rd_2==rd_2), XM_rd_2 != 5'b0);
and Q_andj1_2(Q_j1_2, MW_regWrite_2, (MW_rd_2==rd_2), MW_rd_2 != 5'b0);
and Q_andj2_2(Q_j2_2, XM_regWrite_2, (XM_rd_2==rd_2), XM_rd_2 != 5'b0);

assign jrMux2 = Q_j2_2 ? 4'd8 
				: ( Q_j1_2 ? 4'd4
				: ( Q_j2_1 ? 4'd2
				: ( Q_j1_1 ? 4'd1
				: 4'b0 )))
				;
	
				
endmodule