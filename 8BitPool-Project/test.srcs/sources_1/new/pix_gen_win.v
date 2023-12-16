`timescale 1ns / 1ps

module pix_gen_win(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg[3:0] red = 0,
    output reg[3:0] green = 0,
    output reg[3:0] blue = 0
    );
    
    
//    (*ROM_STYLE="block"*) reg [7:0] winBall_data [0:15839]; // 110x144
//    (*ROM_STYLE="block"*) reg [11:0] winBall_pal [0:159];
    
//    (*ROM_STYLE="block"*) reg [7:0] youWin_data  [0:19319]; // 276x70
//    (*ROM_STYLE="block"*) reg [11:0] youWin_pal [0:178];
    
    reg [11:0] colText;
    
    initial 
        colText <= 0;
        
    reg [7:0] addr;

//    initial
//    begin
//        $readmemh("winBall_data.mem", winBall_data);
//        $readmemh("winBall_pal.mem", winBall_pal);
        
//        $readmemh("you_win_data.mem", youWin_data);
//        $readmemh("you_win_pal.mem", youWin_pal);
//    end
    
    always @(posedge clk_d)
    begin
        if(video_on)
        begin
//            if (pixel_x >= 186 && pixel_x < 186+276 && pixel_y >= 199 && pixel_y < 199+70)
//            begin
//                addr = youWin_data[pixel_x-186 + 276*(pixel_y-199)];
//                colText = {youWin_pal[addr]};         
//            end
//            else
//                colText = 12'h000;

//            if (pixel_x >= 186 && pixel_x < 186+276 && pixel_y >= 199 && pixel_y < 199+70 & colText != 12'h000)
//            begin
//                {red, green, blue} <= colText;
//            end
//            else
//            if (pixel_x >= 266 && pixel_x < 266+110 && pixel_y >= 152 && pixel_y < 152+144)
//            begin
//                addr = winBall_data[pixel_x-266 + 110*(pixel_y-152)];
//                {red, green, blue} <= {winBall_pal[addr]};         
//            end   
//            else
                {red, green, blue} <= 12'h234;
        end
        else
            {red, green, blue} <= 12'h0;
    end
endmodule
