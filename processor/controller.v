module controller(in0, in1, in2, in3, in4, in5, in6, in7, in8, in21, in22, control, regWrite, ALUSrc, 
                  branch, JP, JR, JAL, MemRead, MemWrite,MemToReg,bex, setx);

		input in0, in1, in2,	in3, in4, in5, in6, in7, in8, in21, in22, control;
		wire regWrite1, ALUSrc1, branch1, JP1, JR1, JAL1, MemRead1, MemWrite1, MemToReg1, bex1, setx1;
		output regWrite,  ALUSrc,  branch, bex, JP,  JR,  JAL,  MemRead,  MemWrite,  MemToReg, setx;			
		//think about what other signals you may need
		//passed down in the latch? 

		or or1(regWrite1, in0, in5, in8, in3, in21);	 //R, addi, lw		//noop acts like an R instruction			
		or or2(ALUSrc1, in2, in5, in7, in8, in3, in21); //bne, addi, sw, lw, jal
		or or3(branch1, in2, in6); //bne, blt
		or or4(JP1, in1, 1'b0);	//j		
		or or5(JR1, in4, 1'b0); //jr
		or or6(JAL1, in3, 1'b0); //jal
		or or7(MemRead1, in8, 1'b0); //lw
		or or8(MemWrite1, in7, 1'b0); //sw
		or or9(MemToReg1, in8, 1'b0);	//lw	
		or or10(bex1, in22, 1'b0); //bex
		or or11(setx1, in21, 1'b0);//setx

		//using and gates instead of assign, should be faster

		wire control_not;
		not(control_not, control);
		and and2(regWrite, regWrite1, control_not);
		and and3(ALUSrc, ALUSrc1, control_not);
		and and4(branch, branch1, control_not);
		and and5(JP, JP1, control_not);
		and and6(JR, JR1, control_not);
		and and7(JAL, JAL1, control_not);
		and and8(MemRead, MemRead1, control_not);
		and and9(MemWrite, MemWrite1, control_not);
		and and10(MemToReg, MemToReg1, control_not);
		and and11(bex, bex1, control_not); //bex
      and and12(setx, setx1, control_not); 

			
endmodule						