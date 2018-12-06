module hazardLogicNewInstr(JR, bex, DX_regWrite, DX_regWrite2, FD_regWrite1, clock, reset, DX_MemRead, DX_MemRead2, DX_rs, DX_rs2, DX_rd, DX_rd2, FD_rt, FD_rs, FD_rd,
 FD_rd1, XM_rd, XM_rd2, branch, xm_MemRead, xm_MemRead2, FDWrite, PCWrite, DXWrite, XMWrite, control, aluOp, dataReady);

input DX_MemRead, DX_MemRead2, branch, xm_MemRead, xm_MemRead2, clock, reset, DX_regWrite, DX_regWrite2, bex, JR,dataReady, FD_regWrite1 ;
input [4:0] DX_rs, DX_rd, FD_rt, FD_rs, FD_rd,XM_rd, XM_rd2, DX_rs2, DX_rd2, aluOp, FD_rd1;
output PCWrite, FDWrite, DXWrite, XMWrite, control;

//stall?
wire hazard1, hazard2, hazard3,stall;
wire [2:0] s, s1;
//checking if the rs, rd and rt are equal to any of the registers in pipeline being written to
wire compareRs = (DX_rd==FD_rs);
wire compareRs2 = (DX_rd2==FD_rs); //comparing to rd in line 2
wire compareRs3 = (FD_rs == FD_rd1); //comparing to older instruction

wire compareRt = (DX_rd==FD_rt);
wire compareRt2 = (DX_rd2==FD_rt); //comparing to rd in line 2
wire compareRt3 = (FD_rt == FD_rd1); //comparing to older instruction

wire compareRd = (FD_rd==DX_rd);
wire compareRd2 = (FD_rd == DX_rd2);//2
wire compareRd3 = (FD_rd == FD_rd1);

wire xmRd = (FD_rd ==XM_rd);
wire xmRd2 = (FD_rd ==XM_rd2); //2

wire xmRs = (FD_rs ==XM_rd);
wire xmRs2 = (FD_rs ==XM_rd2);//2


wire rdNull = (DX_rd != 5'b0); //rd not equal null
wire rdNull2 = (DX_rd2 != 5'b0);
wire rdNullFD = (FD_rd1 != 5'b0);
wire xmRdNull = (XM_rd != 5'b0);
wire xmRdNull2 = (XM_rd2 != 5'b0);


///////////////STALLS////////////////////

///stals for older instruction apply for younger but not vice versa
//adding stall for younger instruction, meaning flushing it and loading again in the fetch
// it doesnt matter what instruction is in the older inst fd latch if there is dependency you have to stall
wire stallYoung, stallYoung1, hazardY, hazardY1;
or orY(hazardY, compareRs3, compareRt3);
and andY(stallYoung, rdNullFD, FD_regWrite1, hazardY);

or orY2(hazardY1, compareRd3, compareRs3);
and andY2(stallYoung1, branch, FD_regWrite1, rdNullFD, hazardY1); // data hazard and a branch

or or1(hazard1, compareRs, compareRt);
and and1(s[0], DX_MemRead, rdNull, hazard1); //data hazard and a load so stall

wire hazard12;
or orP1(hazard12, compareRs2, compareRt2);
and andP1(s1[0], DX_MemRead2, rdNull2, hazard12); //data hazard in pipe 2 with load in pipe 2 so stall


or or2(hazard2, compareRd, compareRs);
and and2(s[1], branch, DX_regWrite, rdNull, hazard2); // data hazard and a branch

wire hazard22;
or orP2(hazard22, compareRd2, compareRs2);
and andP2(s1[1], branch, DX_regWrite2, rdNull, hazard22); // data hazard with pipe2  and it is a branch so stall

or or3(hazard3, xmRd, xmRs);
and and3(s[2], xm_MemRead, branch, xmRdNull, hazard3); // data hazard with load in xm

wire hazard32;
or orP3(hazard32, xmRd2, xmRs2);
and andP3(s1[2], xm_MemRead2, branch, xmRdNull2, hazard32); // data hazard with load in xm

//stall for bex?  //not using bex in our test benches so do not need this
wire stallB1, stallBB, stallB;
and aa(stallB1, DX_regWrite, bex, DX_rd==5'd30);
and aaa(stallBB, XM_rd ==5'd30, bex, xm_MemRead);
or orr(stallB, stallBB, stallB1);
 
//stall for jr -- not using jr either
wire stallJ1, stallJ, stallJJ;
and jj(stallJ1, DX_regWrite, JR, compareRd, rdNull);
and aaj(stallJJ, xmRd, JR, xm_MemRead, xmRdNull);
or orj(stallJ, stallJJ, stallJ1);

//stall for multdiv - not using mult div
wire multdivOp, not_ready, multStall;
or ormultstall(multdivOp, (aluOp==5'd6), (aluOp==5'd7));
not notReady(not_ready, dataReady);
and stallNotReady(multStall, multdivOp, not_ready);
assign DXWrite = multStall ? 1'b0 : 1'b1;
assign XMWrite = multStall ? 1'b0 : 1'b1;

or bigOR(stall, s[0], s[1], s[2], s1[0], s1[1], s1[2], stallYoung, stallYoung1);//stallB, stallJ); //,multStall

wire Stall,MULT;
dffe_ref drf(Stall, stall, ~clock, 1'b1, reset);
dffe_ref drf1(MULT, multStall, ~clock, 1'b1, reset);

assign FDWrite = Stall ? 1'b0 : 1'b1;
assign PCWrite = Stall ? 1'b0 : 1'b1;
assign control = MULT ? 1'b0 :  Stall; //MULT? //control when on inserts no ops in the next latch


endmodule