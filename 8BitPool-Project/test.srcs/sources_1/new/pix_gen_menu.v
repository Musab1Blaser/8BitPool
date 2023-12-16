`timescale 1ns / 1ps

module pix_gen_menu(
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg[3:0] red = 0,
    output reg[3:0] green = 0,
    output reg[3:0] blue = 0
    );
    
    
    (*ROM_STYLE="block"*) reg [7:0] start_button_data [0:7649]; // 153x50
    (*ROM_STYLE="block"*) reg [11:0] start_button_pal [0:211];
    
    (*ROM_STYLE="block"*) reg [7:0] balls_data  [0:19207]; // 196x98
    (*ROM_STYLE="block"*) reg [11:0] balls_pal [0:187];
    
    (*ROM_STYLE="block"*) reg [7:0] bitpool_data [0:26315]; // 306x86
    (*ROM_STYLE="block"*) reg [11:0] bitpool_pal [0:237];
    
    reg [7:0] addr;

    initial
    begin
        $readmemh("start_button_data.mem", start_button_data);
        $readmemh("start_button_pal.mem", start_button_pal);
        
        $readmemh("8bitpool_data.mem", bitpool_data);
        $readmemh("8bitpool_pal.mem", bitpool_pal);
        
        
        $readmemh("balls_data.mem", balls_data);
        $readmemh("balls_pal.mem", balls_pal);
    end
    
    always @(posedge clk_d)
    begin
        if(video_on)
            if (pixel_x >= 165 && pixel_x < 165+306 && pixel_y >= 50 && pixel_y < 50+86)
            begin
                addr = bitpool_data[pixel_x-165 + 306*(pixel_y-50)];
                {red, green, blue} <= {bitpool_pal[addr]};         
            end
            else 
            if (pixel_x >= 220 && pixel_x < 220+196 && pixel_y >= 220 && pixel_y < 220+98)
            begin
                addr = balls_data[pixel_x-220 + 196*(pixel_y-220)];
                {red, green, blue} <= {balls_pal[addr]};         
            end
            else if (pixel_x >= 240 && pixel_x < 240+153 && pixel_y >= 392 && pixel_y < 392+50)
            begin
                addr = start_button_data[pixel_x-240 + 153*(pixel_y-392)];
                {red, green, blue} <= {start_button_pal[addr]};         
            end
            else
            {red, green, blue} <= 12'h040;
        else
            {red, green, blue} <= 12'h0;
    end
endmodule
