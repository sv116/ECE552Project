module barrel(in_data, in, shamt, out);

input [31:0] in_data;
input in; // in = 0 ==SRA, in=1 == SLL
input [4:0] shamt;
output [31:0] out;

wire [31:0] w1, w2, w3, w4, w5;
wire [31:0] out16, out8, out4, out2, out1;
wire [31:0] outL16, outL8, outL4, outL2, outL1;
wire [31:0] s1, s2, s3, s4, s5;

bit16_SLL x1(in_data, outL16);
bit16_SRA y1(in_data, out16);
assign s1 = in ? outL16 : out16;
assign w1 =  shamt[4] ? s1: in_data;

bit8_SLL x2(w1, outL8);
bit8_SRA y2(w1, out8);
assign s2 = in ? outL8 : out8;
assign w2 =  shamt[3] ? s2 : w1;

bit4_SLL x3(w2, outL4);
bit4_SRA y3(w2, out4);
assign s3 = in ? outL4 : out4;
assign w3 =  shamt[2] ? s3 : w2;

bit2_SLL x4(w3, outL2);
bit2_SRA y4(w3, out2);
assign s4 = in ? outL2 : out2;
assign w4 =  shamt[1] ? s4 : w3;

bit1_SLL x5(w4, outL1);
bit1_SRA y5(w4, out1);
assign s5 = in ? outL1 : out1;
assign w5 =  shamt[0] ? s5 : w4;

assign out = w5;
endmodule