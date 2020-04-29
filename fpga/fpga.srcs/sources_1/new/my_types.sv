`ifndef MY_TYPES_SV
`define MY_TYPES_SV
/**
 * type definitions
 **/

typedef struct packed {
 logic[12:0] x;
 logic[12:0] y;
} sprite;

typedef struct packed {
  logic[3:0] r;
  logic[3:0] b;
  logic[3:0] g;
} rbg;

typedef struct packed {
  rbg rbg;
  logic alpha;  //transparency bit
} rbga;

module my_types(

    );
endmodule
`endif