module addr_decode(addr,rom_sel,ram_sel);
output rom_sel,ram_sel;
input [12:0] addr;
reg rom_sel,ram_sel;

always @ (addr)
begin
casex(addr)
13'b11xxxxxxxxxxx:{rom_sel,ram_sel}<=2'b01;
13'b0xxxxxxxxxxxx:{rom_sel,ram_sel}<=2'b10;
13'b10xxxxxxxxxxx:{rom_sel,ram_sel}<=2'b10;
default:{rom_sel,ram_sel}<=2'b00;
endcase
end
endmodule 
