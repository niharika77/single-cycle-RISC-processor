`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2019 12:23:34
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb();
reg [15:0] operand1;
reg [15:0] operand2;
reg [2:0] ALUop;
wire [15:0] result;
wire carry;
wire overflow;
wire negative;
wire zero;

ALU #(.width(16))
        alu(
            .operand1(operand1),
            .operand2(operand2),
            .ALUop(ALUop),
            .result(result),
            .carry(carry),
            .overflow(overflow),
            .negative(negative),
            .zero(zero)   //[carry(C),overflow(V),negative(N),zero(Z)]
           );
           
 initial
  begin
   operand1 = 16'h0029;
   operand2 = 16'h0012;
   ALUop = 3'b001;
   
   #10
   operand1 = 16'h9819;
   operand2 = 16'h0010;
   ALUop = 3'b001;
  end          

endmodule
