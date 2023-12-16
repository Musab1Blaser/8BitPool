`timescale 1ns / 1ps

module pix_gen_game_over(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg[3:0] red = 0,
    output reg[3:0] green = 0,
    output reg[3:0] blue = 0
    );
    
    
    (*ROM_STYLE="block"*) reg [7:0] replay_data [0:3599]; // 60x60
    (*ROM_STYLE="block"*) reg [11:0] replay_pal [0:196];
    
    (*ROM_STYLE="block"*) reg [7:0] gameover_data  [0:25489]; // 359x71
    (*ROM_STYLE="block"*) reg [11:0] gameover_pal [0:205];
    
    
    reg [7:0] addr;

    initial
    begin
        $readmemh("Replay_data.mem", replay_data);
        $readmemh("Replay_pal.mem", replay_pal);
        
        $readmemh("GameOver_data.mem", gameover_data);
        $readmemh("GameOver_pal.mem", gameover_pal);
    end
    
    always @(posedge clk_d)
    begin
        if(video_on)
            if (pixel_x >= 268 && pixel_x < 268+60 && pixel_y >= 373 && pixel_y < 373+60)
            begin
                addr = replay_data[pixel_x-268 + 60*(pixel_y-373)];
                {red, green, blue} <= {replay_pal[addr]};         
            end
            else if (pixel_x >= 130 && pixel_x < 130+359 && pixel_y >= 167 && pixel_y < 167+71)
            begin
                addr = gameover_data[pixel_x-130 + 359*(pixel_y-167)];
                {red, green, blue} <= {gameover_pal[addr]};         
            end
            else
            {red, green, blue} <= 12'h234;
        else
            {red, green, blue} <= 12'h0;
    end
endmodule
