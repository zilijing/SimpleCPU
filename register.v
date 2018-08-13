`timescale 1 ns / 1 ns
module register(opc_iraddr,data,ena,clk,rst);
output [15:0] opc_iraddr;
input [7:0] data;
input ena,clk,rst;
reg[15:0] opc_iraddr;
reg state;


always @(clk)
begin
if(rst)
begin
opc_iraddr<= 16'h0000;
state <= 0;
end
else 
  begin
    if(ena)
	 begin
	 casex(state)
	 1'b0:begin
	 opc_iraddr[15:8] <=data;
	 state <=1;
	 end
	 1'b1:begin
	 opc_iraddr[7:0] <= data;
	 state <=0;
	 end
	 default : begin
	         opc_iraddr[15:0] <= 16'hxxxx;
				state <=1'bx;
				end
	endcase 
	end
	else
	state <=1'b0;
	end
	end
	endmodule
	