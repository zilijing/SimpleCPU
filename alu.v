`timescale 1 ns / 1 ns
module alu(clk,alu_out,zero,data,accum,alu_ena,opcode);
input clk;
output [7:0] alu_out;
output zero;
input [7:0]data,accum;
input [2:0] opcode;
input alu_ena;
reg [7:0] alu_out;

parameter HLT   = 3'b000,
          SKZ   = 3'd1,
			 ADD   = 3'd2,
			 ANDD  = 3'd3,
			 XORR  = 3'd4,
			 LDA   = 3'd5,
			 STO   = 3'd6,
			 JMP   = 3'd7;
			 
assign zero =! accum;
always @(posedge clk)
  if(alu_ena)
  begin
  casex(opcode)
  HLT:alu_out <= accum;
  SKZ:alu_out <= accum;
  ADD:alu_out <= data+accum;
  ANDD:alu_out <=data&accum;
  XORR:alu_out <=data^accum;
  LDA:alu_out <= data;
  STO:alu_out <=accum;
  JMP:alu_out <=accum;
  default:alu_out <=8'hxx;
  endcase
  end
  endmodule
  

