`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2019 13:40:44
// Design Name: 
// Module Name: instr_fetch
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


module instr_fetch(
                   input reset,
                   input [15:0] npc,
                   input [7:0] cond_address,    //from table1 in ISA
                   input [10:0] uncond_address,  //from table1 in ISA
                   input [5:0] link_address,    //from table1 in ISA
                   input [15:0] register_data_2,
                   input [1:0] branch_type,
               //    input uncondBr, 
                   input BrTaken,
                   input reg_branch,
               //    input [15:0] link_reg,
               //    input link_sel,
                   output [15:0] link_pc,
                   output [15:0] pc
                   );

wire [15:0] extended_cond_address;
wire [15:0] extended_uncond_address;
wire [15:0] extended_link_address;
wire [15:0] branch_address;
//wire [15:0] shifted_address;
wire [15:0] npc1, npc2;
wire [15:0] npc_temp;
//wire carry1, carry2; //carry's from the adders used below

sign_extend #(.width(8)) sign1(
                               .input_i(cond_address),
                               .extended_address(extended_cond_address)
                               );

sign_extend #(.width(11)) sign2(
                              .input_i(uncond_address),
                              .extended_address(extended_uncond_address)
                                );

sign_extend #(.width(6)) sign3(
                              .input_i(link_address),
                              .extended_address(extended_link_address)
                                );                                
                                    
mux4x1 #(.width(16)) mux4x1_1
                            (
                             .in1(extended_cond_address),
                             .in2(extended_uncond_address),
                             .in3(extended_link_address),
                             .in4(register_data_2),
                             .sel(branch_type),
                             .out(branch_address)
                              );
     

adder_16bit add1(      //branched adder
                 .a(branch_address),
                 .b(npc),
                 .cin(1'b0),
                 .s(npc_temp)    //since we are not using carry
                 );              //it's declared as a wire inside adder
                                 //if you wanna use it. change it to output and connect it here!
                 
                 
                 
 //selecting whether register branch or not
 //if yes, then register value will dirctly go to PC
 //i.e PC = register_data2 
 mux2x1 #(.width(16)) mux2x1_5
                              (
                                .in1(npc_temp),
                                .in2(register_data_2),
                                .sel(reg_branch),
                                .out(npc1)
                               );            
 
adder_16bit add2(
                .a(16'h0001),   //PC only increments by 1 if branch not taken
                .b(npc),
                .cin(1'b0),
                .s(npc2)
                ); 
  
assign link_pc = npc2;                   
//wire [15:0] wire_pc;

//THINK UPON IT Whether to have a one more MUX with select line as reset or not!
wire final_branch_sel;
             
mux2x1 #(.width(1)) mux2x1_2
             (
               .in1(BrTaken),
               .in2(1'b0),
               .sel(reset),
               .out(final_branch_sel)
              );            
              
mux2x1 #(.width(16)) mux2x1_1
                            (
                             .in1(npc2),       
                             .in2(npc1),    
                             .sel(final_branch_sel),                     
                             .out(pc)          
                             );

endmodule
