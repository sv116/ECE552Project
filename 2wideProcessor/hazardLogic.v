module hazardLogic(JR, bex, DX_regWrite, clock, reset, DX_MemRead, DX_rs, DX_rd, FD_rt, FD_rs, FD_rd, XM_rd, branch, 
                   xm_MemRead, FDWrite, PCWrite, DXWrite, XMWrite, control, aluOp, dataReady);

input DX_MemRead, branch, xm_MemRead, clock, reset, DX_regWrite, bex, JR,dataReady ;
input [4:0] DX_rs, DX_rd, FD_rt, FD_rs, FD_rd,XM_rd, aluOp;
output PCWrite, FDWrite, DXWrite, XMWrite, control;

//stall?
wire hazard1, hazard2, hazard3,stall;
wire [2:0] s;
//
wire compareRs = (DX_rd==FD_rs);
wire compareRt = (DX_rd==FD_rt);
wire compareRd = (FD_rd==DX_rd);
wire xmRd = (FD_rd ==XM_rd);
wire xmRs = (FD_rs ==XM_rd);
wire rdNull = (DX_rd != 5'b0);
wire xmRdNull = (XM_rd != 5'b0);

///////////////STALLS////////////////////

or or1(hazard1, compareRs, compareRt);
and and1(s[0], DX_MemRead, rdNull, hazard1); //data hazard and a load so stall

or or2(hazard2, compareRd, compareRs);
and and2(s[1], branch, DX_regWrite, rdNull, hazard2); // data hazard and a branch

or or3(hazard3, xmRd, xmRs);
and and3(s[2], xm_MemRead, branch, xmRdNull, hazard3); // data hazard with load in xm

//stall for bex?
wire stallB1, stallBB, stallB;
and aa(stallB1, DX_regWrite, bex, DX_rd==5'd30);
and aaa(stallBB, XM_rd ==5'd30, bex, xm_MemRead);
or orr(stallB, stallBB, stallB1);
 
//stall for jr
wire stallJ1, stallJ, stallJJ;
and jj(stallJ1, DX_regWrite, JR, compareRd, rdNull);
and aaj(stallJJ, xmRd, JR, xm_MemRead, xmRdNull);
or orj(stallJ, stallJJ, stallJ1);

//stall for multdiv
wire multdivOp, not_ready, multStall;
or ormultstall(multdivOp, (aluOp==5'd6), (aluOp==5'd7));
not notReady(not_ready, dataReady);
and stallNotReady(multStall, multdivOp, not_ready);
assign DXWrite = multStall ? 1'b0 : 1'b1;
assign XMWrite = multStall ? 1'b0 : 1'b1;

or bigOR(stall, s[0], s[1], s[2], stallB, stallJ); //,multStall

wire Stall,MULT;
dffe_ref drf(Stall, stall, ~clock, 1'b1, reset);
dffe_ref drf1(MULT, multStall, ~clock, 1'b1, reset);

assign FDWrite = Stall ? 1'b0 : 1'b1;
assign PCWrite = Stall ? 1'b0 : 1'b1;
assign control = MULT ? 1'b0 :  Stall; //MULT?


endmodule