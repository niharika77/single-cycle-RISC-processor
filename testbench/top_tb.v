`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2019 15:17:38
// Design Name: 
// Module Name: top_tb
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


module top_tb();
reg clk;
reg reset;
wire [15:0] result;
reg [1:0] test;
 
top top(
        .clk(clk),
        .reset(reset),
        .result(result),
        .test(test)
        );
 
initial 
 begin
  clk = 1'b1;
 end       
 
always #5 clk = ~clk;

initial 
 begin
  test = 2'b00;
  reset = 1'b1;
  #20
  reset = 1'b0;
  
          
#1000
$finish;
 end       
        

         
        
        
        
        
        
endmodule
