`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2019 13:19:01
// Design Name: 
// Module Name: mux2x1
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


module mux2x1 #(parameter width = 16)(
              input [width-1:0] in1,       
              input [width-1:0] in2,    
              input sel,                     
              output [width-1:0] out          
              );
      
             
      assign out = sel?in2:in1;        
       
endmodule
