`timescale 1ns / 1ps


/**
 * A demo of our VGA controller
 *
 * Shows a color thing 
 **/

module vga_demo
#(parameter SPRCOUNT = 3)
(
    input 	 clk_100mhz,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output 	 Hsync,
    output 	 Vsync
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

   
   sprite [SPRCOUNT-1:0] sprites;
   // actually have our sprite logic
   logic_box(clk_25hz, sprites);
   
   // sprite display
   rbga sprite_rbga;
   sprite_box(.x(pix_x), .y(pix_y), .sprites(sprites), .out_rbga(sprite_rbga));
   // draw background
   rbga bg_rbga;
   bg_box bg(.x(pix_x), .y(pix_y), .out_rbga(bg_rbga));
   
   // also get a line
   rbga h_line;
   h_line_at_200(.x(pix_x), .y(pix_y), .rbga(h_line)); 
   // mix our signals together
   rbga final_rbga;

   `define MIX(I1,I2,O) \
   rbga_overlay(.rbga_1(I1), .rbga_2(I2), .rbga_out(O));

   // our 
   rbga fg_rbga;
   `MIX(h_line, sprite_rbga, fg_rbga);
   
   `MIX(fg_rbga, bg_rbga, final_rbga);
   
   assign vgaRed = active & final_rbga.alpha? final_rbga.rbg.r:0;
   assign vgaBlue = active & final_rbga.alpha? final_rbga.rbg.b:0;
   assign vgaGreen = active & final_rbga.alpha?final_rbga.rbg.g:0;
  
endmodule

/**
 * This is where we're handling our business logic
 **/

module logic_box
#(parameter SPRCOUNT = 3)
   (input clk_25hz,
    output sprite [SPRCOUNT-1:0] sprites);
  
   // sprite logic: just bounce around a bit aimlessly
   // updating the logic at 100 times per second
   initial begin
      foreach(sprites[i]) begin
         sprites[i].x = 10 + 10*i;
	     sprites[i].y = 30 + 20*i;
	     sprites[i].tile_idx = i;
      end
   end
   always @(posedge clk_25hz) begin
   foreach(sprites[i]) begin
	 sprites[i].x = (sprites[i].x >= 640 - 16)? 0: sprites[i].x + 1;
	 sprites[i].y = (sprites[i].y >= 480 - 16)? 0: sprites[i].y + 1;
   end
   end
  endmodule
/**
 * This module is just for apply colors over each other (left side dominant)
 **/
module rbga_overlay(input rbga rbga_1, input rbga rbga_2, output rbga rbga_out);
   assign rbga_out = rbga_1.alpha?rbga_1:rbga_2;
endmodule // rbga_overlay

