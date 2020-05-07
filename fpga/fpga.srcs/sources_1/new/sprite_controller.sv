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
   output rbga out_rbga
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

   // get the tile x, y for the tile  
   wire [2:0] tile_x;
   wire [2:0] tile_y;
   assign tile_x = x - sp_x;
   assign tile_y = y - sp_y;
   
   rbga gfx_rbga;
   gfx_data(sprite_data.tile_idx, tile_x, tile_y, gfx_rbga);
   localparam ALL_ONE = 12'b111111111111;
   assign out_rbga = '{visible?ALL_ONE:0, gfx_rbga.rbg};
   
endmodule
