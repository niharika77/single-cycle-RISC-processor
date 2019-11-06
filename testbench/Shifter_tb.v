`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2019 14:13:49
// Design Name: 
// Module Name: Shifter_tb
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


module Shifter_tb();
 reg [15:0] value;
 reg [1:0] shift_type;
 reg [15:0] distance;
 wire [15:0] result;

 shifter shift(
	           .value(value),  
               .shift_type(shift_type),   //comes from the controller
	           .distance(distance),     //read_data2
	           .result(result)
	          );
	          
initial 
 begin
  value = 16'h9816;
  distance = 16'h0003;
  shift_type = 2'b00;
  #10
  value = 16'h8816;
  distance = 16'h0003;
  shift_type = 2'b01;
  #10  
  value = 16'hf816;
  distance = 16'h0003;
  shift_type = 2'b10;
  #10
  value = 16'h9816;
  distance = 16'h0004;
  shift_type = 2'b11;
 
 end	          
	          
	          
	          
	          
	          
endmodule
