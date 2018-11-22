module instruction_splitter(instruction, opcode, rd, rs, rt, immediate, target);

input [31:0] instruction;
output [4:0] opcode, rd, rs, rt;
output [16:0] immediate;
output [26:0] target;
assign opcode = instruction[31:27];
assign rd = instruction[26:22];
assign rs = instruction[21:17];
assign rt = instruction[16:12];
assign immediate = instruction[16:0];
assign target = instruction[26:0];

endmodule