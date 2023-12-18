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
        
    reg [7:0] addr;
    
    (*ROM_STYLE="block"*) reg [7:0] shots_text_data [0:1242]; // 54x23
    (*ROM_STYLE="block"*) reg [11:0] shots_text_pal [0:128];

    (*ROM_STYLE="block"*) reg [7:0] score_text_data [0:1295]; // 54x24
    (*ROM_STYLE="block"*) reg [11:0] score_text_pal [0:115];
    
    (*ROM_STYLE="block"*) reg [7:0] best_text_data [0:965]; // 42x23
    (*ROM_STYLE="block"*) reg [11:0] best_text_pal [0:104];
        
    (*ROM_STYLE="block"*) reg [7:0] s0_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s0_pal [0:72];    
    
    (*ROM_STYLE="block"*) reg [7:0] s1_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s1_pal [0:53];    
    
    (*ROM_STYLE="block"*) reg [7:0] s2_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s2_pal [0:68];    
    
    (*ROM_STYLE="block"*) reg [7:0] s3_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s3_pal [0:71];    
    
    (*ROM_STYLE="block"*) reg [7:0] s4_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s4_pal [0:74];    
    
    (*ROM_STYLE="block"*) reg [7:0] s5_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s5_pal [0:78];    
    
    (*ROM_STYLE="block"*) reg [7:0] s6_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s6_pal [0:85];    
    
    (*ROM_STYLE="block"*) reg [7:0] s7_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s7_pal [0:76];    
    
    (*ROM_STYLE="block"*) reg [7:0] s8_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s8_pal [0:69];    
    
    (*ROM_STYLE="block"*) reg [7:0] s9_data [0:434]; // 15x29
    (*ROM_STYLE="block"*) reg [11:0] s9_pal [0:68];

    initial
    begin
        $readmemh("shots_data.mem", shots_text_data);
        $readmemh("shots_pal.mem", shots_text_pal);
        
        $readmemh("score_text_data.mem", score_text_data);
        $readmemh("score_text_pal.mem", score_text_pal);

        $readmemh("best_text_data.mem", best_text_data);
        $readmemh("best_text_pal.mem", best_text_pal);
    
        $readmemh("0_data.mem", s0_data);
        $readmemh("0_pal.mem", s0_pal);

        $readmemh("1_data.mem", s1_data);
        $readmemh("1_pal.mem", s1_pal);

        $readmemh("2_data.mem", s2_data);
        $readmemh("2_pal.mem", s2_pal);

        $readmemh("3_data.mem", s3_data);
        $readmemh("3_pal.mem", s3_pal);

        $readmemh("4_data.mem", s4_data);
        $readmemh("4_pal.mem", s4_pal);

        $readmemh("5_data.mem", s5_data);
        $readmemh("5_pal.mem", s5_pal);

        $readmemh("6_data.mem", s6_data);
        $readmemh("6_pal.mem", s6_pal);

        $readmemh("7_data.mem", s7_data);
        $readmemh("7_pal.mem", s7_pal);

        $readmemh("8_data.mem", s8_data);
        $readmemh("8_pal.mem", s8_pal);

        $readmemh("9_data.mem", s9_data);
        $readmemh("9_pal.mem", s9_pal);
    end
        
    
    
    always @(posedge clk_d)
    begin
      if (video_on) // if in frame
      // attempt to draw based off priority: score -> cue -> white ball -> other balls -> corner holes -> board bg -> board border
      begin
        if (pixel_x > 25 & pixel_x < 25 + 54 & pixel_y > 12 & pixel_y < 12 + 23) // shots
        begin
            addr = shots_text_data[pixel_x-25 + 54*(pixel_y-12)];
            {red, green, blue} <= {shots_text_pal[addr]};   
        end
        else if (pixel_x > 456 & pixel_x < 456 + 42 & pixel_y > 13 & pixel_y < 13 + 23) // best
        begin
            addr = best_text_data[pixel_x-456 + 42*(pixel_y-13)];
            {red, green, blue} <= {best_text_pal[addr]};   
        end
        else if (pixel_x > 504 & pixel_x < 504 + 54 & pixel_y > 12 & pixel_y < 12 + 24) // score
        begin
            addr = score_text_data[pixel_x-504 + 54*(pixel_y-12)];
            {red, green, blue} <= {score_text_pal[addr]};   
        end
        
        else if (pixel_x >= 90 & pixel_x < 90 + 15 & pixel_y >= 10 & pixel_y < 10 + 29) // score tens
        begin
            if (strokes1 == 0)
            begin
                addr = s0_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s0_pal[addr]}; 
            end
            
            else if (strokes1 == 1)
            begin
                addr = s1_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s1_pal[addr]};
            end

            else if (strokes1 == 2)
            begin
                addr = s2_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s2_pal[addr]};
            end

            else if (strokes1 == 3)
            begin
                addr = s3_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s3_pal[addr]};
            end

            else if (strokes1 == 4)
            begin
                addr = s4_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s4_pal[addr]};
            end

            else if (strokes1 == 5)
            begin
                addr = s5_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s5_pal[addr]};
            end

            else if (strokes1 == 6)
            begin
                addr = s6_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s6_pal[addr]};
            end

            else if (strokes1 == 7)
            begin
                addr = s7_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s7_pal[addr]};
            end

            else if (strokes1 == 8)
            begin
                addr = s8_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s8_pal[addr]};
            end

            else if (strokes1 == 9)
            begin
                addr = s9_data[pixel_x-90 + 15*(pixel_y-10)];
                {red, green, blue} <= {s9_pal[addr]};
            end
        end
        
        else if (pixel_x >= 104 & pixel_x < 104 + 15 & pixel_y >= 10 & pixel_y < 10 + 29) // score units
        begin
            if (strokes0 == 0)
            begin
                addr = s0_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s0_pal[addr]};
            end

            else if (strokes0 == 1)
            begin
                addr = s1_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s1_pal[addr]};
            end

            else if (strokes0 == 2)
            begin
                addr = s2_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s2_pal[addr]};
            end

            else if (strokes0 == 3)
            begin
                addr = s3_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s3_pal[addr]};
            end

            else if (strokes0 == 4)
            begin
                addr = s4_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s4_pal[addr]};
            end

            else if (strokes0 == 5)
            begin
                addr = s5_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s5_pal[addr]};
            end

            else if (strokes0 == 6)
            begin
                addr = s6_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s6_pal[addr]};
            end

            else if (strokes0 == 7)
            begin
                addr = s7_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s7_pal[addr]};
            end

            else if (strokes0 == 8)
            begin
                addr = s8_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s8_pal[addr]};
            end

            else if (strokes0 == 9)
            begin
                addr = s9_data[pixel_x-104 + 15*(pixel_y-10)];
                {red, green, blue} <= {s9_pal[addr]};
            end
        end
        
        else if (pixel_x >= 568 & pixel_x < 568 + 15 & pixel_y >= 10 & pixel_y < 10 + 29) // best score tens
        begin
            if (beststrokes1 == 0)
            begin
                addr = s0_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s0_pal[addr]};
            end

            else if (beststrokes1 == 1)
            begin
                addr = s1_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s1_pal[addr]};
            end

            else if (beststrokes1 == 2)
            begin
                addr = s2_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s2_pal[addr]};
            end

            else if (beststrokes1 == 3)
            begin
                addr = s3_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s3_pal[addr]};
            end

            else if (beststrokes1 == 4)
            begin
                addr = s4_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s4_pal[addr]};
            end

            else if (beststrokes1 == 5)
            begin
                addr = s5_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s5_pal[addr]};
            end

            else if (beststrokes1 == 6)
            begin
                addr = s6_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s6_pal[addr]};
            end

            else if (beststrokes1 == 7)
            begin
                addr = s7_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s7_pal[addr]};
            end

            else if (beststrokes1 == 8)
            begin
                addr = s8_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s8_pal[addr]};
            end

            else if (beststrokes1 == 9)
            begin
                addr = s9_data[pixel_x-568 + 15*(pixel_y-10)];
                {red, green, blue} <= {s9_pal[addr]};
            end
        end
        
        else if (pixel_x >= 587 & pixel_x < 587 + 15 & pixel_y >= 10 & pixel_y < 10 + 29) // best score units
        begin
            if (beststrokes0 == 0)
            begin
                addr = s0_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s0_pal[addr]};
            end

            else if (beststrokes0 == 1)
            begin
                addr = s1_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s1_pal[addr]};
            end

            else if (beststrokes0 == 2)
            begin
                addr = s2_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s2_pal[addr]};
            end

            else if (beststrokes0 == 3)
            begin
                addr = s3_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s3_pal[addr]};
            end

            else if (beststrokes0 == 4)
            begin
                addr = s4_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s4_pal[addr]};
            end

            else if (beststrokes0 == 5)
            begin
                addr = s5_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s5_pal[addr]};
            end

            else if (beststrokes0 == 6)
            begin
                addr = s6_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s6_pal[addr]};
            end

            else if (beststrokes0 == 7)
            begin
                addr = s7_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s7_pal[addr]};
            end

            else if (beststrokes0 == 8)
            begin
                addr = s8_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s8_pal[addr]};
            end

            else if (beststrokes0 == 9)
            begin
                addr = s9_data[pixel_x-587 + 15*(pixel_y-10)];
                {red, green, blue} <= {s9_pal[addr]};
            end
        end
            
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
