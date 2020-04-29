`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2020 12:35:53 AM
// Design Name: 
// Module Name: log_box_tb
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


module log_box_tb(

    );
    
    reg clk;
    initial begin
       clk = 0;
    end
    sprite [3:0] sprites;
    logic_box logic_box(clk, sprites);
    always begin
       clk = ~clk; #1;
    end
endmodule
