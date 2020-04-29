`timescale 1ns / 1ps
`include "my_types.sv"
/**
 * Background 
 **/
module bg_box(
	      input wire [12:0] x,
	      input wire [12:0] y,
	      output 	   rbga out_rbga
    );
   rb_b_black(x, y, out_rbga);
endmodule


module h_line_at_200(input wire [12:0] x, input wire [12:0] y, output rbga rbga);
   // horizontal line => constant y
   localparam ALL_ONE = 12'b111111111111;
   assign rbga.alpha = y==200?1:0;
   assign rbga.rbg = ALL_ONE;
endmodule

module rb_b_black(input wire [12:0] x, input wire [12:0] y , output rbga rbga);
  // just have some light blue/black gradiant going on
   assign rbga.alpha = 1;
   assign rbga.rbg.r= 0;
   assign rbga.rbg.b = ~(x[8:6] + y[8:6]);
   assign rbga.rbg.g = 0;
endmodule

//module rainbow_gen(input [12:0] x, input [12:0] y, output [3:0] r, output [3:0] g, output [3:0] b, input active);
//  // 12 
//// TODO figure out better gen technique

//  /**
//  We'll draw 16 bands (one for each value of blue),
  
//   each band will be 640x30
   
//   640 is for R evaluation (32px each)
//   30 is for G evaluation  (2px each)
  
//    on the 16 bands of B we will also just go for 32px each because it's divisible by 2
//  **/
  
//    assign b = active? y[10:7]:0;
//    assign r = active? x[8:5]:0;
//    assign g = active? y[3:0]:0;

//endmodule 
