`timescale 1ns / 1ps

module pix_gen_pool(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input [9:0] w_ball_x,
    input [9:0] w_ball_y,
    input video_on,
    output reg[3:0] red = 2,
    output reg[3:0] green = 2,
    output reg[3:0] blue = 2
    );
    
    localparam bg_border = 'h743;
    localparam bg_board = 'h596;
    
    always @(posedge clk_d)
    begin
        if (pixel_x > w_ball_x - 15 & pixel_x < w_ball_x + 15 & pixel_y > w_ball_y - 15 & pixel_y < w_ball_y + 15)
            red <= 4'hf;
        else
        begin
            if (pixel_x > 20 & pixel_x < 620 & pixel_y > 40 & pixel_y < 440)
            begin
                  red <= 4'h4;
            
//                if (pixel_x < 40 | pixel_x > 600 | pixel_y < 60 | pixel_y > 420)
//                    red <= 4'h4;
//                else
//                    red <= 4'h1;
            end
            else
                {red, green, blue} <= 12'h0;
        end
    end
endmodule
