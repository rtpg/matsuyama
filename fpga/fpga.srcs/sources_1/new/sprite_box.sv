`timescale 1ns / 1ps
`include "my_types.sv"
/**
 * 
 **/
module sprite_box
#(parameter SPRCOUNT = 3)
(
 input wire [12:0] x,
 input wire [12:0] y,
 input wire   sprite [SPRCOUNT-1:0] sprites,
 output       rbga out_rbga
    );

   rbga [SPRCOUNT-1:0] sprite_rbga;
   
`define SPR(IDX) \
   sprite_controller spr_ctrl_``IDX``(.x(x), .y(y), .out_rbga(sprite_rbga[IDX]), .sprite_data(sprites[IDX]));

   genvar i;
   
   generate
      for(i=0; i<SPRCOUNT; i++) begin
	 `SPR(i)
      end
   endgenerate

   rbga [SPRCOUNT-1:0] mixed_signals;

   assign mixed_signals[0] = sprite_rbga[0];
   
   generate
      for(i=0;i<SPRCOUNT-1;i++) begin
	    rbga_overlay(mixed_signals[i], sprite_rbga[i+1], mixed_signals[i+1]);
      end
   endgenerate
   assign out_rbga = mixed_signals[SPRCOUNT-1];

endmodule
