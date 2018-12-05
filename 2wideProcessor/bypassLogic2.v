module bypassLogic2 ( MW_regWrite_1, MW_regWrite_2,
							XM_regWrite_1, XM_regWrite_2,
							XM_memWrite_1, XM_memWrite_2,
							MW_MemToReg_1, MW_MemToReg_2,
							DX_rs_1, DX_rs_2,
							DX_rt_1, DX_rt_2,
							XM_rd_1, XM_rd_2,
							MW_rd_1, MW_rd_2,
							rs, rd, // get rd and rs from both pipes -> control hazards
                     ALUin1A, ALUin1B, ALUin2A, ALUin2B,
							muxM, muxBranchA, muxBranchB, bexMux, jrMux);

input MW_regWrite_1, XM_memWrite_1, MW_MemToReg_1, XM_regWrite_1,
		MW_regWrite_2, XM_memWrite_2, MW_MemToReg_2, XM_regWrite_2;
input [4:0] DX_rs_1, DX_rt_1, XM_rd_1, MW_rd_1,
				DX_rs_2, DX_rt_2, XM_rd_2, MW_rd_2,
				rs, rd; //rs and rd are from the decode stage and used for calcBranch
				
output [1:0] ALUin1A, ALUin1B, ALUin2A, ALUin2B;
output [3:0] muxBranchA, muxBranchB;
output muxM;


//data hazards
wire mem1, mem2, ex1;
wire P_hazard1_1, P_hazard2_1, P_hazard1_2, P_hazard2_2,
	  Q_hazard1_1, Q_hazard2_1, Q_hazard1_2, Q_hazard2_2,
	  hazard3, hazard4,
	  P_hAm1_1, P_hAm2_1, P_hAm1_2, P_hA2_2,
	  Q_hAm1_1, Q_hAm2_1, Q_hAm1_2, Q_hA2_2,
	  P_hBm1_1, P_hBm2_1, P_hBm1_2, P_hBm2_2,
	  Q_hBm1_1, Q_hBm2_1, Q_hBm1_2, Q_hBm2_2;
wire [1:0] bM;


// 1_1: from MW_1 latch
// 2_1: from XM_1 latch
// 1_2: from MW_2 latch
// 2_2: from XM_2 latch

// PIPE 1 - P

or P_or_1(P_hazard1_1, MW_rd_1==DX_rs_1, MW_rd_1 == DX_rt_1);
or P_or_2(P_hazard2_1, XM_rd_1==DX_rs_1, XM_rd_1 == DX_rt_1);
or P_or_3(P_hazard1_2, MW_rd_2==DX_rs_1, MW_rd_2 == DX_rt_1);
or P_or_4(P_hazard2_2, XM_rd_2==DX_rs_1, XM_rd_2 == DX_rt_1);

and P_and1_1(P_mem1_1, MW_regWrite_1, MW_rd_1 != 5'b0, P_hazard1_1); 
and P_and2_1(P_mem2_1, XM_regWrite_1, XM_rd_1 != 5'b0, P_hazard2_1);
and P_and1_2(P_mem1_2, MW_regWrite_2, MW_rd_2 != 5'b0, P_hazard1_2); 
and P_and2_2(P_mem2_2, XM_regWrite_2, XM_rd_2 != 5'b0, P_hazard2_2);

//haven't done this yet
and and3(ex1, MW_MemToReg_1, XM_memWrite_1, MW_rd_1 != 5'b0, MW_rd_1==XM_rd_1);

// first source (A) - pipe 1

and P_andA1_1(P_hAm1_1, MW_rd_1==DX_rs_1, P_mem1_1);
and P_andA2_1(P_hAm2_1, XM_rd_1==DX_rs_1, P_mem2_1);
and P_andA1_2(P_hAm1_2, MW_rd_2==DX_rs_1, P_mem1_2);
and P_andA2_2(P_hAm2_2, XM_rd_2==DX_rs_1, P_mem2_2);


assign ALUin1A =    P_hAm2_2 ? 4'd8 
					 : ( P_hAm1_2 ? 4'd4
					 : ( P_hAm2_1 ? 4'd2
					 : ( P_hAm1_1 ? 4'd1
					 : 4'b0 )))
				;
					

//second source (B) - pipe 1

and andB1_1(hBm1_1, MW_rd_1==DX_rt_1, mem1_1);
and andB2_1(hBm2_1, XM_rd_1==DX_rt_1, mem2_1);
and andB1_2(hBm1_2, MW_rd_2==DX_rt_1, mem1_1);
and andB2_2(hBm2_2, XM_rd_2==DX_rt_1, mem2_1);

assign ALUin1B =  hBm2_2 ? 4'd8 
					 : ( hBm1_2 ? 4'd4
					 : ( hBm2_1 ? 4'd2
					 : ( hBm1_1 ? 4'd1
					 : 4'b0 )))
				;
			
// pipe 2 - Q			
			
or Q_or_1(Q_hazard1_1, MW_rd_1==DX_rs_2, MW_rd_1 == DX_rt_2);
or Q_or_2(Q_hazard2_1, XM_rd_1==DX_rs_2, XM_rd_1 == DX_rt_2);
or Q_or_3(Q_hazard1_2, MW_rd_2==DX_rs_2, MW_rd_2 == DX_rt_2);
or Q_or_4(Q_hazard2_2, XM_rd_2==DX_rs_2, XM_rd_2 == DX_rt_2);
			
and Q_and1_1(Q_mem1_1, MW_regWrite_1, MW_rd_1 != 5'b0, Q_hazard1_1); 
and Q_and2_1(Q_mem2_1, XM_regWrite_1, XM_rd_1 != 5'b0, Q_hazard2_1);
and Q_and1_2(Q_mem1_2, MW_regWrite_2, MW_rd_2 != 5'b0, Q_hazard1_2); 
and Q_and2_2(Q_mem2_2, XM_regWrite_2, XM_rd_2 != 5'b0, Q_hazard2_2);

// first source (A) - pipe 2
					 
and Q_andA1_1(Q_hAm1_1, MW_rd_1==DX_rs_2, Q_mem1_1);
and Q_andA2_1(Q_hAm2_1, XM_rd_1==DX_rs_2, Q_mem2_1);
and Q_andA1_2(Q_hAm1_2, MW_rd_2==DX_rs_2, Q_mem1_2);
and Q_andA2_2(Q_hAm2_2, XM_rd_2==DX_rs_2, Q_mem2_2);


assign ALUin2A =    Q_hAm2_2 ? 4'd8 
					 : ( Q_hAm1_2 ? 4'd4
					 : ( Q_hAm2_1 ? 4'd2
					 : ( Q_hAm1_1 ? 4'd1
					 : 4'b0 )))
				;
					
//second source (B) - pipe 2

and Q_andB1_1(Q_hBm1_1, MW_rd_1==DX_rt_2, mem1_1);
and Q_andB2_1(Q_hBm2_1, XM_rd_1==DX_rt_2, mem2_1);
and Q_andB1_2(Q_hBm1_2, MW_rd_2==DX_rt_2, mem1_1);
and Q_andB2_2(Q_hBm2_2, XM_rd_2==DX_rt_2, mem2_1);

assign ALUin2B =    Q_hBm2_2 ? 4'd8 
					 : ( Q_hBm1_2 ? 4'd4
					 : ( Q_hBm2_1 ? 4'd2
					 : ( Q_hBm1_1 ? 4'd1
					 : 4'b0 )))
				;
					 
					 
assign muxM = ex1 ? 1'b1 : 1'b0;

//control hazards
// rd and rs from both pipes -> hazard3 & 4 for both pipes
wire c1, c2, h1, h2, h3, h4, cc1, cc2;
wire [1:0] muxC, muxC2;

or or3(hazard3, MW_rd_1==rs, MW_rd_1 == rd);
or or4(hazard4, XM_rd_1==rs, XM_rd_1 == rd);

and andc1(c1, MW_regWrite_1, MW_rd_1 != 5'b0, hazard3); 
and andc2(c2, XM_regWrite_1, XM_rd_1 != 5'b0, hazard4);

//input rs
//01 take the reg value from MW latch
//10 ---------------         XM
and andC1(h1, MW_rd_1==rs, c1);
and andC2(h2, XM_rd_1==rs, c2);
or orC(cc1, h1, h2);
assign muxC = h2 ?  2'd2 : 2'b1;
assign muxBranchA = cc1 ? muxC : 2'b0; 
 
//input rd 
and andC3(h3, MW_rd_1==rd, c1);
and andC4(h4, XM_rd_1==rd, c2);
or orC1(cc2, h3, h4);
assign muxC2 = h4 ?  2'd2 : 2'b1;
assign muxBranchB = cc2 ? muxC2 : 2'b0; 

//bex hazard
wire b1, b2, b3, b4;
output [1:0] bexMux;
assign b1 = MW_rd_1==5'd30;
assign b2 = XM_rd_1==5'd30;
and andBex1(b3, MW_regWrite_1, b1);
and andBex2(b4, XM_regWrite_1, b2);
//assign bM = b4 ? 2'd2 : 2'b1;
//assign bexMux = b3 ? bM : 2'b0;
assign bM = b3 ? 2'd1 : 2'b0;
assign bexMux = b4 ? 2'd2 : bM;


//jr bypass --- rdmux
wire j1, j2;
output [1:0] jrMux;
wire [1:0] j3;	
and jj(j1, MW_regWrite_1, (MW_rd_1==rd), MW_rd_1 != 5'b0);
and jjj(j2, XM_regWrite_1, (XM_rd_1==rd), XM_rd_1 != 5'b0);

assign j3 = j1 ? 2'd1 : 2'b0;
assign jrMux = j2 ? 2'd2 : j3;

endmodule