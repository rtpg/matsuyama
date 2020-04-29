`default_nettype none
`ifndef MY_TYPES_SV
`define MY_TYPES_SV
/**
 * type definitions
 **/
// we can have up to 128 tiles for now
typedef logic[7:0] tile_idx;

typedef struct packed {
   // current tile position
   logic [12:0] x;
   logic [12:0] y;
   // the actual tile to draw with
   tile_idx tile_idx; 
} sprite;

typedef struct packed {
   logic [3:0] r;
   logic [3:0] b;
   logic [3:0] g;
} rbg;

typedef struct packed {
   rbg rbg;
   logic       alpha;  //transparency bit
} rbga;


// 256 colors on a tile to use
typedef logic[8:0] tile_color;
typedef struct packed {
   tile_color [7:0][7:0] img;
   logic       pallete;
} tile_img;


// the graphics data holds most of our important bits
typedef struct packed {
   tile_img [127:0] tiles;
   // TODO add pallette data
} gfx_data;


module my_types(

    );
endmodule
`endif
