`timescale 1ns / 1ps
module processor(A,B,inst,clk,rst,OUT);
input [31:0] A,B;
input [31:0] inst;
input clk, rst;
wire [31:0] rs1, rs2;
output [31:0] OUT;
wire [31:0] rd;
wire [4:0] rs1_addr, rs2_addr, rd_addr;
wire [6:0] opcode, p;
wire [2:0] func;
wire [3:0] cs;
// Instatiation of all  module (Register_bank, Decoder,Controller,ALU)

reg_bank REGB(A,B,rs1_addr,rs2_addr,rd_addr,rd,rs1,rs2,rst,clk);
inst_decoder ID(inst,opcode,clk,p,func,rs1_addr,rs2_addr,rd_addr);
controller CL(p,func,cs);
ALU AL(rs1,rs2,cs,rd,OUT);
endmodule

//module for register bank

module reg_bank (A,B,rs1_addr,rs2_addr,rd_addr,rd,rs1,rs2,rst,clk);
input [31:0] A,B,rd;
input [4:0] rs1_addr,rs2_addr,rd_addr;
input rst,clk;
integer k;
output reg [31:0] rs1,rs2;
reg [31:0] rb [0:31];
always@(posedge clk)
begin
if(rst==1) begin
for(k=0;k<32;k=k+1)
rb[k]=0;
end
else
begin
rb[rs1_addr]=A;
rb[rs2_addr]=B;
rs1=rb[rs1_addr];
rs2=rb[rs2_addr];
rb[rd_addr]=rd;
end

end
endmodule



//MODULE FOR instruction decoder
module inst_decoder(inst,opcode,clk,p,func,rs1_addr,rs2_addr,rd_addr);
input [31:0] inst;
input clk;
output reg [6:0] opcode, p;
output reg [2:0] func;
output reg [4:0] rs1_addr, rs2_addr, rd_addr;

always@(inst)
begin
opcode = inst[6:0];
p = inst[31:25];
func = inst[14:12];
rs1_addr = inst[19:15];
rs2_addr = inst[24:20];
rd_addr = inst[11:7];
end
endmodule


//Module for controller
module controller(p,func,cs);
input [2:0] func;
input [6:0] p;
output reg [3:0] cs;
always@(func,p)
begin
cs = {p[5],func};
end
endmodule

//  Module for ALU
module ALU(rs1,rs2,cs,rd,OUT);
input [3:0] cs;
output reg [31:0] OUT;
input [31:0] rs1, rs2;
output reg [31:0] rd;
parameter ADD = 4'b0000, SUB = 4'b1000, SLL = 4'b0001, SLT = 4'b0010, SLTU = 4'b0011, XOR = 4'b0100, SRL = 4'b0101, SRA = 4'b1101, OR = 4'b0110, AND = 4'b0111;
always@(cs,rs1,rs2)
begin
case(cs)
ADD: begin
rd = rs1+rs2;
OUT=rd;
end
SUB: begin
rd = rs1-rs2;
OUT=rd;
end

SLL:begin
rd = rs1 << rs2[4:0];
OUT=rd;
end
SLT: begin
if(rs1<rs2)
begin
rd = 1;
OUT=rd;
end
else
begin
rd = 0;
OUT=rd;
end
end
SLTU: begin
if(rs1<rs2)
begin
rd = 1;
OUT=rd;
end
else
begin
rd = 0;
OUT=rd;
end
end
XOR: begin
rd = rs1 ^ rs2;
OUT=rd;
end

SRL: begin
rd = rs1 >> rs2[4:0];
OUT=rd;
end

SRA: begin rd = rs1 >>> rs2[4:0];
OUT=rd;
end

OR: begin rd = rs1 | rs2;
OUT=rd;
end

AND: begin
rd = rs1 & rs2;
OUT=rd;
end

default: begin
rd = 0;
OUT=rd;
end
endcase
end
endmodule
















