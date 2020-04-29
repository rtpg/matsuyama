`timescale 1ns / 1ps
`include "my_types.sv"

/**
 * This module takes in x,y coords and provides a stream of sprite pixels
 * (at least while they are visible)
 **/
module sprite_controller(
   input wire [12:0]  x,
   input wire [12:0]  y,
   // x,y coordinates of the sprite data
   input sprite  sprite_data,
   output rbga rbga
			 );
   
   
   wire [12:0] 	 sp_x, sp_y;

   assign sp_x = sprite_data.x;
   assign sp_y = sprite_data.y;

   wire visible;
   assign visible = (
		     ((sp_x - 8) < x) & (x <= sp_x)
		     ) & 
		    (
		     ((sp_y - 8) < y) & (y <= sp_y)
		     );

   localparam ALL_ONE = 12'b111111111111;
   assign rbga = '{visible?ALL_ONE:0, visible};
   
endmodule
