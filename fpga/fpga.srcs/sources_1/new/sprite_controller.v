`timescale 1ns / 1ps

/**
 * This module takes in x,y coords and provides a stream of sprite pixels
 * (at least while they are visible)
 **/
module sprite_controller(
   input [12:0]  x,
   input [12:0]  y,
   // x,y coordinates of the sprite data
   input [25:0]  sprite_data,
			 
   output [11:0] rbg,
   output 	 visible
			 );
   
   
   wire [12:0] 	 sp_x, sp_y;

   assign sp_x = sprite_data[12:0];
   assign sp_y = sprite_data[25:13];

   assign visible = (
		     ((sp_x - 8) < x) & (x <= sp_x)
		     ) & 
		    (
		     ((sp_y - 8) < y) & (y <= sp_y)
		     );


   localparam ALL_ONE = 12'b111111111111;
   assign rbg = visible?ALL_ONE:0;
   
endmodule
