`timescale 1ns / 1ps

module pix_gen_pool_2(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input cue_on,
    input [3:0] strokes0,
    input [3:0] strokes1,
    input [3:0] beststrokes0,
    input [3:0] beststrokes1,
    input [2:0] rot,
    input [3:0] strength,
    input [10:0] w_ball_x,
    input [10:0] w_ball_y,
    input [10:0] r_ball_x,
    input [10:0] r_ball_y,
    input [10:0] b_ball_x,
    input [10:0] b_ball_y,
    input [10:0] g_ball_x,
    input [10:0] g_ball_y,
    input [10:0] y_ball_x,
    input [10:0] y_ball_y,
    input [10:0] m_ball_x,
    input [10:0] m_ball_y,
    input [10:0] c_ball_x,
    input [10:0] c_ball_y,
    
    input [9:0] top_left_x,
    input [9:0] top_left_y,
    input [9:0] bottom_left_x,
    input [9:0] bottom_left_y,
    input [9:0] top_middle_x,
    input [9:0] top_middle_y,
    input [9:0] bottom_middle_x,
    input [9:0] bottom_middle_y,
    input [9:0] top_right_x,
    input [9:0] top_right_y,
    input [9:0] bottom_right_x,
    input [9:0] bottom_right_y,
    input video_on,
    output reg[3:0] red = 0,
    output reg[3:0] green = 0,
    output reg[3:0] blue = 0
//    ,output [3:0] cue_red,
//    output [3:0] cue_green,
//    output [3:0] cue_blue
    );
    
    localparam bg_border = 'h743; // board border color
    localparam bg_board = 'h596; // board bg color
    
    wire cue_display; // is the current pixel part of cue sprite
    wire [3:0] cue_red, cue_green, cue_blue; // color of current pixel according to cue sprite
   
    // update cue_display, cue_red, cue_green, cue_blue based on position of current pixel wrt cue position and state
    cue_sprite cue (
    clk_d,
    cue_on,
    rot,
    pixel_x,
    pixel_y,
    w_ball_x,
    w_ball_y,
    cue_display,
    cue_red,
    cue_green,
    cue_blue
    );
    
    // Stores in B(block) RAM - good for larger storage
    (*ROM_STYLE="block"*) reg ball_design [0:840]; // stores shape of ball in bit file. 0s for black, 1s for white.

    initial
        $readmemb("ball3.mem", ball_design); // read memory file as bytes
    
    always @(posedge clk_d)
    begin
      if (video_on) // if in frame
      // attempt to draw based off priority: cue -> white ball -> other balls -> corner holes -> board bg -> board border
      begin
        if (pixel_x > 40 & pixel_x < 40 + 10*strokes1 + strokes0 & pixel_y < 30 & pixel_y > 10)
            {red, green, blue} <= 12'hf00;
            
        else if (pixel_x > 500 & pixel_x < 500 + 10*beststrokes1 + beststrokes0 & pixel_y < 30 & pixel_y > 10)
            {red, green, blue} <= 12'hf00;
            
        else if (cue_display & (cue_red + cue_green + cue_blue) > 3)
            {red, green, blue} <= {cue_red, cue_green, cue_blue};
        else
        if (pixel_x >= (w_ball_x - 14) & pixel_x <= (w_ball_x + 14) & pixel_y >= (w_ball_y - 14) & pixel_y <= (w_ball_y + 14) & ball_design[pixel_x-w_ball_x+14 + 30*(pixel_y-w_ball_y+14)])
            {red, green, blue} <= 12'hfff;
        else
        if (pixel_x >= (r_ball_x - 14) & pixel_x <= (r_ball_x + 14) & pixel_y >= (r_ball_y - 14) & pixel_y <= (r_ball_y + 14) & ball_design[pixel_x-r_ball_x+14 + 30*(pixel_y-r_ball_y+14)])
            {red, green, blue} <= 12'hf00;        
        else 
        if (pixel_x >= (b_ball_x - 14) & pixel_x <= (b_ball_x + 14) & pixel_y >= (b_ball_y - 14) & pixel_y <= (b_ball_y + 14) & ball_design[pixel_x-b_ball_x+14 + 30*(pixel_y-b_ball_y+14)])
            {red, green, blue} <= 12'h00f;        
        else 
        if (pixel_x >= (g_ball_x - 14) & pixel_x <= (g_ball_x + 14) & pixel_y >= (g_ball_y - 14) & pixel_y <= (g_ball_y + 14) & ball_design[pixel_x-g_ball_x+14 + 30*(pixel_y-g_ball_y+14)])
            {red, green, blue} <= 12'h0f0;        
        else 
        if (pixel_x >= (y_ball_x - 14) & pixel_x <= (y_ball_x + 14) & pixel_y >= (y_ball_y - 14) & pixel_y <= (y_ball_y + 14) & ball_design[pixel_x-y_ball_x+14 + 30*(pixel_y-y_ball_y+14)])
            {red, green, blue} <= 12'hff0;
        else
        if (pixel_x >= (m_ball_x - 14) & pixel_x <= (m_ball_x + 14) & pixel_y >= (m_ball_y - 14) & pixel_y <= (m_ball_y + 14) & ball_design[pixel_x-m_ball_x+14 + 30*(pixel_y-m_ball_y+14)])
            {red, green, blue} <= 12'hf0f;
        else
        if (pixel_x >= (c_ball_x - 14) & pixel_x <= (c_ball_x + 14) & pixel_y >= (c_ball_y - 14) & pixel_y <= (c_ball_y + 14) & ball_design[pixel_x-c_ball_x+14 + 30*(pixel_y-c_ball_y+14)])
            {red, green, blue} <= 12'h0ff;
        else
        // corner holes
        if (pixel_x >= (top_left_x - 14) & pixel_x <= (top_left_x + 14) & pixel_y >= (top_left_y - 14) & pixel_y <= (top_left_y + 14) & ball_design[pixel_x-top_left_x+14 + 30*(pixel_y-top_left_y+14)])
            {red, green, blue} <= 12'h0;
        else
        if (pixel_x >= (bottom_left_x - 14) & pixel_x <= (bottom_left_x + 14) & pixel_y >= (bottom_left_y - 14) & pixel_y <= (bottom_left_y + 14) & ball_design[pixel_x-bottom_left_x+14 + 30*(pixel_y-bottom_left_y+14)])
            {red, green, blue} <= 12'h0;
        else
        if (pixel_x >= (top_middle_x - 14) & pixel_x <= (top_middle_x + 14) & pixel_y >= (top_middle_y - 14) & pixel_y <= (top_middle_y + 14) & ball_design[pixel_x-top_middle_x+14 + 30*(pixel_y-top_middle_y+14)])
            {red, green, blue} <= 12'h0;
        else
        if (pixel_x >= (bottom_middle_x - 14) & pixel_x <= (bottom_middle_x + 14) & pixel_y >= (bottom_middle_y - 14) & pixel_y <= (bottom_middle_y + 14) & ball_design[pixel_x-bottom_middle_x+14 + 30*(pixel_y-bottom_middle_y+14)])
            {red, green, blue} <= 12'h0;
        else
        if (pixel_x >= (top_right_x - 14) & pixel_x <= (top_right_x + 14) & pixel_y >= (top_right_y - 14) & pixel_y <= (top_right_y + 14) & ball_design[pixel_x-top_right_x+14 + 30*(pixel_y-top_right_y+14)])
            {red, green, blue} <= 12'h0;
        else
        if (pixel_x >= (bottom_right_x - 14) & pixel_x <= (bottom_right_x + 14) & pixel_y >= (bottom_right_y - 14) & pixel_y <= (bottom_right_y + 14) & ball_design[pixel_x-bottom_right_x+14 + 30*(pixel_y-bottom_right_y+14)])
            {red, green, blue} <= 12'h0;
        else
        if (pixel_x >= 6 && pixel_x < 15 && pixel_y < 277 && pixel_y >= 198)
            if (pixel_x < 8 | pixel_x >= 13 | pixel_y >= 275 | pixel_y < 200)
                {red, green, blue} <= 12'hfff;
            else
            if (pixel_y >= 275 - 5*strength)
                {red, green, blue} <= 12'hf00;
            else
                {red, green, blue} <= 12'h000;
        else
        begin
            // draw board
            if (pixel_x >= 20 & pixel_x < 620 & pixel_y >= 40 & pixel_y < 440)
                if (pixel_x < 40 | pixel_x >= 600 | pixel_y < 60 | pixel_y >= 420)
                    {red, green, blue} <= bg_border;
                else
                    {red, green, blue} <= bg_board;
            else
                {red, green, blue} <= 12'h0;
        end
      end
      else
        {red, green, blue} <= 12'h0;
    end
endmodule
