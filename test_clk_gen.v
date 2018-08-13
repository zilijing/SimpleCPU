`timescale  1 ns / 1 ns
module test_clk_gen;
reg clk;
reg reset;
wire fetch,alu_ena;
initial
begin
clk= 0;
reset = 0;
#13 reset = 1;
#10 reset = 0;
end
always #5 clk = ~clk;

clk_gen  m(clk,reset,fetch,alu_ena);
endmodule 