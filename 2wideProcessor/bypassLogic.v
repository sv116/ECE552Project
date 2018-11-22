module bypassLogic(MW_regWrite, XM_regWrite, XM_MemWrite, MW_MemToReg, DX_rs, DX_rt, XM_rd, MW_rd, rs, rd,
                    ALUinA, ALUinB, muxM, muxBranchA, muxBranchB, bexMux, jrMux);

input MW_regWrite, XM_MemWrite, MW_MemToReg, XM_regWrite;
input [4:0] DX_rs, DX_rt, XM_rd, MW_rd, rs, rd; //rs and rd are from the decode stage and used for calcBranch
output [1:0] ALUinA, ALUinB,muxBranchA, muxBranchB;
output muxM;


//data hazards
wire mem1, mem2, ex1, hazard1, hazard2, hazard3, hazard4, hAm1, hAm2, hBm1, hBm2, hbm2, bp, bpB;
wire [1:0] aluinA, aluinB, bM;

or or1(hazard1, MW_rd==DX_rs, MW_rd == DX_rt);
or or2(hazard2, XM_rd==DX_rs, XM_rd == DX_rt);

and and1(mem1, MW_regWrite, MW_rd != 5'b0, hazard1); 
and and2(mem2, XM_regWrite, XM_rd != 5'b0, hazard2);
and and3(ex1, MW_MemToReg, XM_MemWrite, MW_rd != 5'b0, MW_rd==XM_rd);

and andA1(hAm1, MW_rd==DX_rs, mem1);
and andA2(hAm2, XM_rd==DX_rs, mem2);
or orA3(bp, hAm1, hAm2);

assign aluinA = hAm2 ?  2'd2 : 2'b1;
assign ALUinA = bp ?  aluinA : 2'b0;

 //second source bypassing
and andB1(hBm1, MW_rd==DX_rt, mem1);
and andB2(hBm2, XM_rd==DX_rt, mem2);
or orB3(bpB, hBm1, hBm2);

assign aluinB = hBm2 ?  2'd2 : 2'b1;
assign ALUinB = bpB ?  aluinB : 2'b0;

assign muxM = ex1 ? 1'b1 : 1'b0;

//control hazards
wire c1, c2, h1, h2, h3, h4, cc1, cc2;
wire [1:0] muxC, muxC2;
or or3(hazard3, MW_rd==rs, MW_rd == rd);
or or4(hazard4, XM_rd==rs, XM_rd == rd);

and andc1(c1, MW_regWrite, MW_rd != 5'b0, hazard3); 
and andc2(c2, XM_regWrite, XM_rd != 5'b0, hazard4);

//input rs
//01 take the reg value from MW latch
//10 ---------------         XM
and andC1(h1, MW_rd==rs, c1);
and andC2(h2, XM_rd==rs, c2);
or orC(cc1, h1, h2);
assign muxC = h2 ?  2'd2 : 2'b1;
assign muxBranchA = cc1 ? muxC : 2'b0; 
 
//input rd 
and andC3(h3, MW_rd==rd, c1);
and andC4(h4, XM_rd==rd, c2);
or orC1(cc2, h3, h4);
assign muxC2 = h4 ?  2'd2 : 2'b1;
assign muxBranchB = cc2 ? muxC2 : 2'b0; 

//bex hazard
wire b1, b2, b3, b4;
output [1:0] bexMux;
assign b1 = MW_rd==5'd30;
assign b2 = XM_rd==5'd30;
and andBex1(b3, MW_regWrite, b1);
and andBex2(b4, XM_regWrite, b2);
//assign bM = b4 ? 2'd2 : 2'b1;
//assign bexMux = b3 ? bM : 2'b0;
assign bM = b3 ? 2'd1 : 2'b0;
assign bexMux = b4 ? 2'd2 : bM;



//jr bypass --- rdmux
wire j1, j2;
output [1:0] jrMux;
wire [1:0] j3;	
and jj(j1, MW_regWrite, (MW_rd==rd), MW_rd != 5'b0);
and jjj(j2, XM_regWrite, (XM_rd==rd), XM_rd != 5'b0);

assign j3 = j1 ? 2'd1 : 2'b0;
assign jrMux = j2 ? 2'd2 : j3;

endmodule