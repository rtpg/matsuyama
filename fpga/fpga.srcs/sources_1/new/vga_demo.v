`timescale 1ns / 1ps


/**
 * A demo of our VGA controller
 *
 * Shows a color thing 
 **/

module vga_demo(
    input 	 clk_100mhz,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output 	 Hsync,
    output 	 Vsync
//    output [10:0] pix_x,
//    output [10:0] pix_y
);

   wire [12:0] pix_x;
   wire [12:0] pix_y;
   wire        active;

   extra_clocks clks(clk_100mhz, clk_100hz, clk_25hz);
   
// we first wire up our controller to generate the right hsync and vsyncs
// as well as pixel calcs
   vga_controller ctrl(
		       .clk_100mhz(clk_100mhz), 
		       .h_sync(Hsync), .v_sync(Vsync),
		       .current_x(pix_x), .current_y(pix_y),
		       .active(active));

   // background display
   wire [11:0]  bgRBG;
   
   rb_b_black bg(.x(pix_x), .y(pix_y), .rbg(bgRBG));

   
   // sprite storage
   reg [25:0] 	sprXY;

   // sprite logic: just bounce around a bit aimlessly
   // updating the logic at 100 times per second
   initial begin
      sprXY[12: 0] = 40;
      sprXY[25: 13] = 30;
   end
   always @(posedge clk_25hz) begin
      sprXY[12:0] = (sprXY[12:0] >= 640)? 0: sprXY[12:0] + 1;
      sprXY[25:13] = (sprXY[25:13] >= 480)? 0: sprXY[25:13] + 1;
   end


   
   // sprite display (including a bit about transparency)
   wire [11:0] 	spriteRBG;
   wire 	spriteVisible;

   sprite_controller spr_ctrl(
			      .x(pix_x),
			      .y(pix_y),
			      .rbg(spriteRBG),
			      .visible(spriteVisible),
			      .sprite_data(sprXY)
			      );

   
   // mix our signals together
   wire [11:0] 	finalRBG;
   
   assign finalRBG = spriteVisible?spriteRBG:bgRBG;

   assign vgaRed = active?finalRBG[3:0]:0;
   assign vgaBlue = active?finalRBG[7:4]:0;
   assign vgaGreen = active?finalRBG[11:8]:0;
   
  
endmodule


module rb_b_black(input [12:0] x, input [12:0] y, output [11:0] rbg);
  // just have some light blue/black gradiant going on
  assign rbg[3:0] = 0;
  assign rbg[7:4] = ~(x[8:6] + y[8:6]);
  assign rbg[11:8] = 0;
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
