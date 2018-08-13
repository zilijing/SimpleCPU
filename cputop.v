

//************************************************************

`timescale 1 ns / 1 ns

`define PERIOD 100
module cputop;
reg reset_req,clock;
integer test;
reg [(2*8):0] mnemonic;
reg [12:0] PC_addr,IR_addr;
wire [7:0] data;
wire [12:0] addr;
wire rd,wr,halt,ram_sel,rom_sel;
wire [2:0] opcode;
wire fetch;
wire [12:0] ir_addr,pc_addr;

//--------------ccpu模块雨地址译码器和rom，ram的连线部分--------
cpu t_cpu(.clk(clock),.reset(reset_req),.halt(halt),.rd(rd),
                      .wr(wr),.addr(addr),.data(data),.opcode(opcode),.fetch(fetch),
							 .ir_addr(ir_addr),.pc_addr(pc_addr));
ram t_ram(.addr(addr[9:0]),.read(rd),.write(wr),.ena(ram_sel),.data(data));

rom t_rom(.addr(addr),.read(rd),.ena(rom_sel),.data(data));

addr_decode t_addr_decode(.addr(addr),.ram_sel(ram_sel),.rom_sel(rom_sel));

//-------------------------cpu模块雨地址译码器和rom，ram的连接部分结束------------------------------
initial
begin
clock = 1;
sys_reset;
test1;
$stop;
test2;
$stop;
test3;
$finish;
end


task test1;
begin
test = 0;
disable MONITOR;
$readmemb("test11.dat",t_rom.memory);
$readmemb("test1.dat",t_ram.ram);
# 1 test = 1;
# 14800 ;
sys_reset;
end
endtask


task test2;
begin
test = 0;
disable MONITOR;
$readmemb("test22.dat",t_rom.memory);
$readmemb("test2.dat",t_ram.ram);
# 1 test = 2;
# 11600 ;
sys_reset;
end
endtask


task test3;
begin
test = 0;
disable MONITOR;
$readmemb("test33.dat",t_rom.memory);
$readmemb("test3.dat",t_ram.ram);
# 1 test = 3;
# 94000 ;
sys_reset;
end
endtask

task sys_reset;
begin

reset_req = 0;
#(`PERIOD*0.7) reset_req = 1;
#(1.5*`PERIOD) reset_req =0;
end
endtask


always@(test)
begin:MONITOR
case(test)
1:begin
while (test == 1)
@(t_cpu.pc_addr)
if((t_cpu.pc_addr%2 == 1)&&(t_cpu.fetch == 1))
begin
# 60 PC_addr <= t_cpu.pc_addr-1;
IR_addr <=t_cpu.ir_addr;
# 340  $strobe ("%t  %h   %s   %h  %h",$time ,PC_addr,mnemonic,IR_addr,data);
end
end

2:begin
while (test == 2)
@(t_cpu.pc_addr)
if((t_cpu.pc_addr%2 == 1)&&(t_cpu.fetch == 1))
begin
# 60 PC_addr <= t_cpu.pc_addr-1;
IR_addr <=t_cpu.ir_addr;
# 340  $strobe ("%t  %h   %s   %h  %h",$time ,PC_addr,mnemonic,IR_addr,data);
end
end


3:begin
while (test == 3)
begin
wait(t_cpu.opcode == 3'h1)
$strobe ("%t   %d",$time,t_ram.ram[10'h2]);
wait(t_cpu.opcode != 3'h1);
end
end
endcase

end



//===================================
always #(`PERIOD/2) clock = ~clock;
always @(t_cpu.opcode)
case(t_cpu.opcode)
3'b000:mnemonic ="HLT";
3'H1  :mnemonic= "SKZ";
3'h2  :mnemonic= "ADD";
3'h3  :mnemonic = "AND";
3'h4  :mnemonic = "XOR";
3'h5  :mnemonic ="LDA";
3'h6  :mnemonic = "STO";
3'h7  :mnemonic = "JMP";
default:mnemonic = "???";
endcase
endmodule
