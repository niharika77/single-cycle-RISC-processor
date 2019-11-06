`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2019 12:22:34
// Design Name: 
// Module Name: instruction_mem_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module instruction_mem_tb();

reg [63:0] address; 
reg clk;
wire [31:0] instruction;

instruction_mem dut(address, clk, instruction);


initial clk=1'b1;

always
 begin
  #5 clk=~clk;
  end
  
initial 
 begin
 #10 address = 1; //@(posedge clk);
 #10 address = 0; //@(posedge clk);
 #10 address = 2; //@(posedge clk);
 #10 address = 4; //@(posedge clk);
 end

endmodule