`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2020 12:08:21 PM
// Design Name: 
// Module Name: gfx_data_tb
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


module gfx_data_tb(

    );
    
    reg [8:0] tile_idx;
    reg [2:0] x;
    reg [2:0] y;
    rbga rbga;
    
    gfx_data gfx(tile_idx, x, y, rbga);
    
    initial begin
       tile_idx = 1;
       x = 0;
       y = 0;
    end
    
    always begin
       x = (x == 7)? 0:x+1;
       y = (x == 0)? (y ==7)? 0: (y+1): y;
       #1;
    end
endmodule
