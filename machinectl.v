`timescale 1 ns / 1 ns
module machinectl(ena,fetch,rst,clk);
input fetch ,rst,clk;
output ena;
reg ena;
reg state;


always @(posedge clk)
begin
if(rst)
begin
ena<=0;
end
else 
if(fetch)
begin 
ena<=1;
end
end
endmodule
