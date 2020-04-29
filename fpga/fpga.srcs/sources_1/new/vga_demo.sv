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
   genvar i;
   
   sprite [SPRCOUNT-1:0] sprXY;

   // sprite logic: just bounce around a bit aimlessly
   // updating the logic at 100 times per second
   initial begin
      foreach(sprXY[i]) begin
         sprXY[i].x = 10 + 10*i;
	     sprXY[i].y = 30 + 20*i;
      end
      // sprXY[0].x = 40;
      // sprXY[0].y = 30;
      // sprXY[1].x = 150;
      // sprXY[1].y = 200;
   end
   always @(posedge clk_25hz) begin
   foreach(sprXY[i]) begin
	 sprXY[i].x = (sprXY[i].x >= 640 - 16)? 0: sprXY[i].x + 1;
	 sprXY[i].y = (sprXY[i].y >= 480 - 16)? 0: sprXY[i].y + 1;
   end
   end

   // sprite display logic
   rbga [SPRCOUNT-1:0] sprite_rbga;
   
   `define SPR(IDX) \
        sprite_controller spr_ctrl_``IDX``(.x(pix_x),.y(pix_y), .rbga(sprite_rbga[IDX]), .sprite_data(sprXY[``IDX``]));
   generate
      for(i=0;i<SPRCOUNT;i++) begin
	 `SPR(i);
      end
   endgenerate

      
   // mix our signals together

   rbga bg_rbga = '{bgRBG, 1};

   rbga h_line;
   h_line_at_200(.x(pix_x), .y(pix_y), .rbga(h_line)); 
   rbga final_rbga;

   rbga [SPRCOUNT-1:0] mixed_signals;
   `define MIX(I1,I2,O) \
   rbga_overlay(.rbga_1(I1), .rbga_2(I2), .rbga_out(O));

   `MIX(h_line, sprite_rbga[0], mixed_signals[0]);
//   assign mixed_signals[0] = sprite_rbga[0];
   generate
      for(i=0;i<SPRCOUNT-1;i++) begin
	 `MIX(mixed_signals[i], sprite_rbga[i +1], mixed_signals[i+1]);
      end
   endgenerate
   `MIX(mixed_signals[SPRCOUNT-1], bg_rbga, final_rbga);
   
   // wire [11:0] 	finalRBG;
   
   // assign finalRBG = sprite_rbga[0].alpha?sprite_rbga[0].rbg:bgRBG;
//   wire [11:0] finalRBG;
//   assign finalRBG = final_rbga.rbg;
//   assign vgaRed = active?finalRBG[3:0]:0;
//   assign vgaBlue = active?finalRBG[7:4]:0;
//   assign vgaGreen = active?finalRBG[11:8]:0;
   assign vgaRed = active & final_rbga.alpha? final_rbga.rbg.r:0;
   assign vgaBlue = active & final_rbga.alpha? final_rbga.rbg.b:0;
   assign vgaGreen = active & final_rbga.alpha?final_rbga.rbg.g:0;
  
endmodule

/**
 * This module is just for apply colors over each other (left side dominant)
 **/
module rbga_overlay(input rbga rbga_1, input rbga rbga_2, output rbga rbga_out);
   assign rbga_out = rbga_1.alpha?rbga_1:rbga_2;
endmodule // rbga_overlay

module h_line_at_200(input [12:0] x, input [12:0] y, output rbga rbga);
   // horizontal line => constant y
   localparam ALL_ONE = 12'b111111111111;
   assign rbga = '{ALL_ONE, y==200?1:0};
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
