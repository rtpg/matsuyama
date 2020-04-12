`timescale 1ns / 1ps

/**
 * This module will just generate a lot of helper clocks
 **/

module extra_clocks(
   input      clk_100mhz,
   output reg clk_100hz,
   output reg clk_25hz
);

   reg [19:0] counter;

   initial begin
      counter = 0;
      clk_100hz = 0;
   end
   
   always @(posedge clk_100mhz) begin
      // 100 hz every million steps,
      // since we are just checking posedge we should change at
      // 500k
      counter = (counter == 500000)?0:counter + 1;
      if (counter == 0) begin
	 clk_100hz = ~clk_100hz;
      end
   end

   reg counter_25hz;

   initial begin
      clk_25hz = 0;
      
   end;
   
   always @(posedge clk_100hz) begin
      counter_25hz = ~counter_25hz;
      if(counter_25hz) begin
	 clk_25hz = ~clk_25hz;
      end
   end

endmodule
