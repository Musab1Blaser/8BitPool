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
    
    
    (*ROM_STYLE="block"*) reg [7:0] start_button_data [0:7497]; // 153x49
    (*ROM_STYLE="block"*) reg [11:0] start_button_pal [0:119];
    
    (*ROM_STYLE="block"*) reg [7:0] balls_data  [0:7938]; // 126x63 
    (*ROM_STYLE="block"*) reg [11:0] balls_pal [0:160];
    
    (*ROM_STYLE="block"*) reg [7:0] bitpool_data [0:10779]; // 196x55
    (*ROM_STYLE="block"*) reg [11:0] bitpool_pal [0:124];
    
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
            if (pixel_x >= 232 && pixel_x < 232+196 && pixel_y >= 100 && pixel_y < 100+55)
            begin
                addr = bitpool_data[pixel_x-232 + 196*(pixel_y-100)];
                {red, green, blue} <= {bitpool_pal[addr]};         
            end
            else 
            if (pixel_x >= 263 && pixel_x < 263+126 && pixel_y >= 174 && pixel_y < 174+63)
            begin
                addr = balls_data[pixel_x-263 + 126*(pixel_y-174)];
                {red, green, blue} <= {balls_pal[addr]};         
            end
            else if (pixel_x >= 244 && pixel_x < 244+153 && pixel_y >= 259 && pixel_y < 259+49)
            begin
                addr = start_button_data[pixel_x-244 + 153*(pixel_y-259)];
                {red, green, blue} <= {start_button_pal[addr]};         
            end
            else
            {red, green, blue} <= 12'h432;
        else
            {red, green, blue} <= 12'h0;
    end
endmodule
