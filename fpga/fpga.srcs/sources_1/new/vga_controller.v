`timescale 1ns / 1ps

/**
 *  This VGA Controller is 640x480, with a 25MHz pixel clock, and a 60Hz refresh rate
 */
module vga_controller(
    input clk_100mhz,
    output reg h_sync,
    output reg v_sync,
    output reg [12:0] current_x,
    output reg [12:0] current_y,
    output reg active
    );
 
 wire pix_clk;
 quarter_clock qclk(clk_100mhz, pix_clk); 
 
  reg [11:0] h_clock_counter;
  reg [1:0] h_sync_state;
  localparam h_pulse = 0;
  localparam h_backporch = 1;
  localparam h_drawing = 2;
  localparam h_frontporch = 3;

  initial begin
     h_clock_counter = 0;
     h_sync_state = h_pulse;
     current_x = 0;
     current_y = 0;
  end

  // hsync state timings
  always @(posedge pix_clk) begin
    h_clock_counter = h_clock_counter == 800? 0: h_clock_counter + 1;
    if(h_clock_counter <= 96) h_sync_state = h_pulse;
    // 96 + 48
    else if(h_clock_counter <= 144) h_sync_state = h_backporch;
    // 96+48+640
    else if(h_clock_counter <= 784) h_sync_state = h_drawing;
    // last little bit
    else h_sync_state = h_frontporch;    
  end
  
  // this might be a place where timing is weird (how to count)
  always @(posedge pix_clk) begin
    case(h_sync_state)
      h_pulse: begin 
          current_x = 0; // make sure this is set properly 
          h_sync = 0;
      end
      h_backporch: begin
         h_sync = 1;
         current_x = 0;
      end
      h_drawing: begin
        h_sync = 1;
        current_x = current_x + 1;
      end
      h_frontporch: begin
        h_sync = 1;
        current_x = 640;
      end
      endcase
   end
   // for the v sync we are going to count based off of h_sync pulses
    
    reg [11:0] v_clock_counter;
    reg [1:0] v_sync_state;
    localparam v_pulse = 0;
    localparam v_backporch = 1;
    localparam v_drawing = 2;
    localparam v_frontporch = 3;


    initial begin
       v_clock_counter = 0;
       v_sync_state = v_pulse;
       current_y = 0;
    end
    
   
   // vsync timings
   always @(negedge h_sync) begin
     v_clock_counter = v_clock_counter == 521? 0: v_clock_counter + 1;
     if(v_clock_counter <= 2) v_sync_state = v_pulse;
     // 2 + 29
     else if(v_clock_counter <= 31) v_sync_state = v_backporch;
     // 2 + 29 + 480
     else if(v_clock_counter <= 511) v_sync_state = v_drawing;
     else v_sync_state = v_frontporch;
   end

    // logic 
   always @(negedge h_sync) begin
    case(v_sync_state)
      v_pulse: begin
        current_y = 0;
        v_sync = 0;
      end
      v_backporch: begin
        v_sync = 1;
        current_y = 0;
      end
      v_drawing: begin
        v_sync = 1;
        current_y = current_y + 1;
      end
      v_frontporch: begin
        v_sync = 1;
        current_y = 480;
      end
    endcase
   end
   
   // handle whether we should be actually drawing to the screen
   always @(posedge pix_clk) begin
     active = (v_sync_state == v_drawing) & (h_sync_state == h_drawing);
   end
endmodule



module quarter_clock(input clk_100mhz, output reg clk_25mhz);
reg counter;

initial begin
  clk_25mhz = 0;
  counter = 0;
end
// this should be 4 times slower because only detecting positive edge
// + counter (so two halvings)
always @(posedge clk_100mhz) begin
   if(counter == 1) begin
      clk_25mhz = ~clk_25mhz;
   end

   counter = ~counter;
end

endmodule