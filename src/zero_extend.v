`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2019 11:26:10
// Design Name: 
// Module Name: zero_extend
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



module zero_extend #(parameter width = 1)(
                   input [width-1:0] input_i,
                   output [15:0] zero_extended_address
                   );
  
  
  assign zero_extended_address[15:width] = 'b0;                 
  assign zero_extended_address[width-1:0] = input_i;  
 
endmodule
