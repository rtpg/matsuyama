`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2020 11:13:51 PM
// Design Name: 
// Module Name: vga_demo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_demo_tb;

 reg clk_100mhz;
 
 initial begin
    clk_100mhz = 0;
 end
 
 always begin
    clk_100mhz <= ~clk_100mhz; #1;
 end
  
 wire [3:0] vgaRed, vgaBlue, vgaGreen;
 wire  Hsync, Vsync;
 vga_demo demo(clk_100mhz, vgaRed, vgaBlue, vgaGreen, Hsync, Vsync);
endmodule
