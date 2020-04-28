/**
 * type definitions
 **/

typedef struct packed {
 logic[12:0] x;
 logic[12:0] y;
} sprite;

typedef struct packed {
  logic[2:0] r;
  logic[2:0] b;
  logic[2:0] g;
} rbg;

typedef struct packed {
  rbg rbg;
  logic alpha;  //transparency bit
} rbga;

module my_types(

    );
endmodule
