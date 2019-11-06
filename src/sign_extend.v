`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2019 13:05:28
// Design Name: 
// Module Name: sign_extend
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


module sign_extend #(parameter width = 1)(
                   input [width-1:0] input_i,
                   output [15:0] extended_address
                   );
                   
  assign extended_address = {{(16-width){input_i[width-1]}},input_i};  
 
endmodule
