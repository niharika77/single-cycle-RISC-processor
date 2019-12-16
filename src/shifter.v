//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 21.01.2019 12:55:32
//// Design Name: 
//// Module Name: shifter
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////

module shifter (
	input wire [15:0]	value,   //read_data1
  input wire [1:0] shift_type,   //comes from the controller
	input wire [15:0] distance,     //read_data2
	output reg signed [15:0] result,
	output reg carry_out,
	output wire negative,
	output wire zero,
	output wire overflow
	);
	
	wire [31:0] double_value;
	wire [3:0] dist_mod;
	wire signed [15:0] value_rotate;
	
	assign value_rotate = value;
	assign dist_mod = distance % 16;
	assign double_value = {value, value};
	assign negative = result[15];
	assign zero = (result == 0);
	assign overflow = 1'b0;
	
	always @(*) begin
		carry_out = 1'b0;
		result = value;
		case(shift_type)
			2'b00 : begin  
						{carry_out, result} = value << distance;
					end
					
			 2'b01 : begin
							if (distance > 0) begin 
								{result, carry_out} = value >> distance - 1;
							end
						end
			 
			 2'b10 : begin
							if (distance > 0) begin
								{result, carry_out} = value_rotate >>> distance - 1;
							end
						end
						
			 2'b11 : begin
							if (dist_mod > 0) begin
								{result, carry_out} = double_value >> dist_mod - 1;
							end
						end
	  endcase
	end

endmodule
