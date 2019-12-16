`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2019 12:41:33
// Design Name: 
// Module Name: top
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


module top(
            input clk,
            input reset,
            input [1:0] test,
            output [15:0] result
           
            );


wire [15:0] instruction;

wire BrTaken;
wire [15:0] link_pc;
wire [15:0] next_address;

//control signals
wire [1:0] Reg1Loc;
wire [1:0] Reg2Loc;
wire [1:0] write_reg;
wire cmp_sel;
wire [1:0] immediate_sel;
wire RegWrite;
wire ALUsrc;
wire [1:0] shift_type;
wire [2:0] ALUop;
wire [3:0] conditions;
wire mem_read;
wire mem_write;
wire [1:0] write_back;
wire cond_branch;
wire uncond_branch;
wire link_branch;
wire reg_branch;
wire [1:0] branch_type;

//register signals
wire [3:0] read_address1;
wire [3:0] read_address2;
wire [3:0] write_address;
wire [3:0] write_address_temp;

wire [15:0] read_data1;
wire [15:0] read_data2;
wire [15:0] write_data;

pc_manager pc_manager(
                      .clk(clk),
                      .reset(reset),
                      .cond_address(instruction[7:0]),
                      .uncond_address(instruction[10:0]),  
                      .link_address(instruction[5:0]),
                      .register_data_2(read_data2), //data read from the register output port 2
                      .branch_type(branch_type),    
                      .BrTaken(BrTaken),
                      .reg_branch(reg_branch),
                      .link_pc(link_pc),
                      .pc_out(next_address)
                  );

//asynchronous instruction memory          
instruction_mem instruction_memory(
                                   .address(next_address), 
                                   //.clk(clk),
                                   .test(test),
                                   .instruction(instruction)
                                      );            

wire alu_shifter;
            
control_unit control_unit(
                         .instruction(instruction),
                         .Reg1Loc(Reg1Loc),
                         .Reg2Loc(Reg2Loc),
                         .write_reg(write_reg),
                         .cmp_sel(cmp_sel),
                         .immediate_sel(immediate_sel),
                         .RegWrite(RegWrite),
                         .ALUsrc(ALUsrc),
                         .shift_type(shift_type),
                         .ALUop(ALUop),
                         .conditions(conditions),
                         .mem_read(mem_read),
                         .mem_write(mem_write),
                         .write_back(write_back),
                         .cond_branch(cond_branch),
                         .uncond_branch(uncond_branch),
                         .link_branch(link_branch),
                         .reg_branch(reg_branch),
                         .branch_type(branch_type),
                         .alu_shifter(alu_shifter)                 
                         );           
 

 //to select the address for the first register           
 mux4x1 #(.width(4)) mux1(
                                      .in1({1'b0,instruction[5:3]}),
                                      .in2({1'b0,instruction[2:0]}),
                                      .in3(4'b1101),   //SP idk wat to do with this!
                                      .in4(4'b0000),
                                      .sel(Reg1Loc),
                                      .out(read_address1)
                                      );            
//to select the address for the second register            
 mux4x1 #(.width(4)) mux2(
                           .in1(instruction[6:3]),
                           .in2({1'b0,instruction[8:6]}),
                           .in3({1'b0,instruction[5:3]}),   
                           .in4({1'b0,instruction[2:0]}),
                           .sel(Reg2Loc),
                           .out(read_address2)
                           );              
//to select the address for the write register
 mux4x1 #(.width(4)) mux3(
                           .in1({1'b0,instruction[2:0]}),
                           .in2({1'b0,instruction[10:8]}),
                           .in3(4'b1110),  //link register when branch and link   
                           .in4(4'b1101),  //SP, idk what to do with this
                           .sel(write_reg),
                           .out(write_address_temp)
                           );
                                       
mux2x1 #(.width(4)) mux4(
                            .in1(write_address_temp),       
                            .in2(4'b1111),    
                            .sel(cmp_sel),                     
                            .out(write_address)          
                            );                  

//wire [15:0] r1, r2;           
register_file register_file(
                            .RegWrite(RegWrite),
                            .write_register(write_address),
                            .write_data(write_data),
                            .clk(clk),
                            .reset(reset),
                            .read_register1(read_address1),
                            .read_register2(read_address2),
                            .read_data1(read_data1),   //read_data1
                            .read_data2(read_data2)  //read_data2
                         //   .out(out)                       
                            );    

             
                                   
            
//immediate values
wire [15:0] immediate1;
wire [15:0] immediate2;
wire [15:0] immediate3;
wire [15:0] immediate4;
wire [15:0] immediate_data;

zero_extend #(.width(8)) zero_extend1(
                                     .input_i(instruction[7:0]),
                                     .zero_extended_address(immediate1)
                                     );

zero_extend #(.width(3)) zero_extend2(
                                     .input_i(instruction[8:6]),
                                     .zero_extended_address(immediate2)
                                     );                               

zero_extend #(.width(7)) zero_extend3(
                                     .input_i(instruction[6:0]),
                                     .zero_extended_address(immediate3)
                                     );            

zero_extend #(.width(5)) zero_extend4(
                                     .input_i(instruction[10:6]),
                                     .zero_extended_address(immediate4)
                                     );
                                     
//to select which immediate to carry forward to ALU
 mux4x1 #(.width(16)) mux5(
                          .in1({{8{1'b0}},instruction[7:0]}),
                          .in2({{13{1'b0}},instruction[8:6]}),
                          .in3({{9{1'b0}},instruction[6:0]}),  
                          .in4({{11{1'b0}},instruction[10:6]}),  
                          .sel(immediate_sel),
                          .out(immediate_data)
                          );               
//select between register data2 and immediate value
wire [15:0] ALU_input2;
           
mux2x1 #(.width(16)) mux6(
                         .in1(read_data2),       
                         .in2(immediate_data),    
                         .sel(ALUsrc),                     
                         .out(ALU_input2)          
                         );                                   

//Final flags
wire carry;
wire negative;
wire overflow;
wire zero;


//ALU unit
wire [15:0] ALU_output;
wire alu_carry;
wire alu_overflow;
wire alu_negative;
wire alu_zero;
                                     
ALU #(.width(16)) ALU_unit(
                           .operand1(read_data1),
                           .operand2(ALU_input2),
                           .ALUop(ALUop),
                           .result(ALU_output),
                           .carry(alu_carry),
                           .overflow(alu_overflow),
                           .negative(alu_negative),
                           .zero(alu_zero)   
                            );
                                                                         
//shifter unit
wire [15:0] shift_output;

wire shift_carry;
wire shift_negative;
wire shift_zero;
wire shift_overflow; //   = 1'b0;

shifter shifter(
                .value(read_data1),  
                .shift_type(shift_type),   
                .distance(read_data2),     
                .result(shift_output),
                .carry_out(shift_carry),
                .negative(shift_negative),
                .zero(shift_zero),
                .overflow(shift_overflow)
                );                                     
                                    
mux2x1 #(.width(1)) mux_carry(
                              .in1(alu_carry),       
                              .in2(shift_carry),    
                              .sel(alu_shifter),                     
                              .out(carry)          
                              );                                    
                                  
mux2x1 #(.width(1)) mux_negative(
                                .in1(alu_negative),       
                                .in2(shift_negative),    
                                .sel(alu_shifter),                     
                                .out(negative)          
                                );                                    
                                                                   
mux2x1 #(.width(1)) mux_overflow(
                                .in1(alu_overflow),       
                                .in2(shift_overflow),    
                                .sel(alu_shifter),                     
                                .out(overflow)          
                                );                                    
                                    
mux2x1 #(.width(1)) mux_zero(
                            .in1(alu_zero),       
                            .in2(shift_zero),    
                            .sel(alu_shifter),                     
                            .out(zero)          
                            );                                     
                                                                 
                                     
//CPSR
wire cpsr_flag;
wire cond;
                                     
CPSR cpsr_block(
                .clk(clk),
                .reset(reset),
                .carry(carry),
                .overflow(overflow),
                .negative(negative),
                .zero(zero),
                .conditions(conditions),  
                .cpsr_flag(cpsr_flag)
                    );                                     

and and1(cond,cond_branch,cpsr_flag);                                             
or or1(BrTaken,cond,link_branch,uncond_branch,reg_branch);

//data memory
wire [15:0] read_data_memory;

data_memory data_memory(
                       .address(ALU_output),
                       .write_data(read_data2),
                       .mem_read(mem_read),
                       .mem_write(mem_write),
                       .clk(clk),
                       .read_data(read_data_memory)
                       );
                                     
//to select the output to write back to the register
 mux4x1 #(.width(16)) mux7(
                         .in1(read_data_memory),
                         .in2(ALU_output),
                         .in3(shift_output),   //SP idk wat to do with this!
                         .in4(link_pc),
                         .sel(write_back),
                         .out(write_data)
                         );    
                
 assign result = write_data;                                    
                                     
                                     
                                     
                                     
endmodule
