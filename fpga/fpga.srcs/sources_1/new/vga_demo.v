`timescale 1ns / 1ps


/**
 * A demo of our VGA controller
 *
 * Shows a color thing 
 **/

module vga_demo(
    input clk_100mhz,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output Hsync,
    output Vsync
//    output [10:0] pix_x,
//    output [10:0] pix_y
);

wire [12:0] pix_x;
wire [12:0] pix_y;
wire active;

// we first wire up our controller to generate the right hsync and vsyncs
// as well as pixel calcs
vga_controller ctrl(.clk_100mhz(clk_100mhz), .h_sync(Hsync), .v_sync(Vsync), .current_x(pix_x), .current_y(pix_y), .active(active));

// we then just take those pixel calcs and generate a nice color signal

rainbow_gen generate_screen_pattern(.x(pix_x), .y(pix_y), .active(active), .r(vgaRed), .b(vgaBlue), .g(vgaGreen));
endmodule

module rainbow_gen(input [12:0] x, input [12:0] y, output [3:0] r, output [3:0] g, output [3:0] b, input active);
  // 12 
// TODO figure out better gen technique

  /**
  We'll draw 16 bands (one for each value of blue),
  
   each band will be 640x30
   
   640 is for R evaluation (32px each)
   30 is for G evaluation  (2px each)
  
    on the 16 bands of B we will also just go for 32px each because it's divisible by 2
  **/
  
    assign b = active? y[10:7]:0;
    assign r = active? x[8:5]:0;
    assign g = active? y[3:0]:0;

endmodule 
