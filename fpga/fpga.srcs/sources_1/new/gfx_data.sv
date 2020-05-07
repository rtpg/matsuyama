`timescale 1ns / 1ps
`include "my_types.sv"
/**
 * This module handles all that is storing the sprite data, etc
 **/
module gfx_data(
		input bit [8:0] tile_idx,
		input bit [2:0] x,
		input bit [2:0] y,
		output rbga rbga
    );
    // pallete data is 768 4-bit values
    
    bit [3:0] pallete [0:768];
    // we can have up to 255 tiles, we just have 4 now though
    byte tiles [0:255*63];
    
    initial begin
        $readmemh("palette.mem", pallete);
        $readmemh("1.mem", tiles, 0, 63);
        $readmemh("2.mem", tiles, 64, 127);
        $readmemh("3.mem", tiles, 128,  191);
        $readmemh("4.mem", tiles, 192, 256);
    end;
    
    // wire [63:0] cur_tile;
    // assign cur_tile = tiles[64*(tile_idx-1):64*tile_idx];
    assign rbga.alpha = 1;
    wire [5:0] idx_in_tile;
    assign idx_in_tile = x * 8 + y;
    byte pallete_idx;
    assign pallete_idx = tiles[tile_idx*64 + idx_in_tile];
    
    assign rbga.rbg = '{pallete[pallete_idx], pallete[pallete_idx + 128], pallete[pallete_idx + 256]};
endmodule
