`timescale 1ns / 1ps

module cue_sprite(
    input clk_d,
    input cue_on,
    input [2:0] rot,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input [10:0] w_ball_x,
    input [10:0] w_ball_y,
    output reg cue_display = 0,
    output reg [3:0] red = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue = 0
//    ,output reg [7:0] addr = 0
    );
    
    (*ROM_STYLE="block"*) reg [7:0] cue_vert [0:364]; // 5x73
    (*ROM_STYLE="block"*) reg [11:0] cue_vert_pal [0:162];
    
    (*ROM_STYLE="block"*) reg [7:0] cue_diag [0:3248]; // 57x57
    (*ROM_STYLE="block"*) reg [11:0] cue_diag_pal [0:95];
    
    // temp storage
//    reg [7:0] r;
//    reg [7:0] g;
//    reg [7:0] b;
    reg [7:0] addr;
    

    initial
    begin
        $readmemh("vert_cue_data_2.mem", cue_vert);
        $readmemh("vert_cue_pal_4.mem", cue_vert_pal);
        
        $readmemh("diag_cue_data.mem", cue_diag);
        $readmemh("diag_cue_pal.mem", cue_diag_pal);
    end
    
    always @(posedge clk_d)
    begin
        if (cue_on)
            begin // fix sprite + rotation indexing for 3,5,7
                if (rot == 0 && pixel_x >= w_ball_x-2 && pixel_x <= w_ball_x+2 && pixel_y >= w_ball_y+20 && pixel_y < w_ball_y+20+73)
                begin
                    addr = cue_vert[pixel_x-w_ball_x+2 + 5*(pixel_y-w_ball_y-20)];
                    {red, green, blue} <= {cue_vert_pal[addr]};
                    cue_display <= 1;
                end
                else
                if (rot == 1 && pixel_x < w_ball_x-20 && 100 + pixel_x >= (100+w_ball_x)-20-57 && pixel_y > w_ball_y+20 && pixel_y <= w_ball_y+20+57)
                begin
                    addr = cue_diag[pixel_x-w_ball_x+20+57 + 57*(pixel_y-w_ball_y-21)];
                    {red, green, blue} <= {cue_diag_pal[addr]};
                    cue_display <= 1;
                end
                else
                if (rot == 2 & 100+pixel_x > (100+w_ball_x)-20-73 & pixel_x <= w_ball_x-20 & pixel_y >= w_ball_y-2 & pixel_y <= w_ball_y+2)
                begin
                    addr = cue_vert[5*(w_ball_x - pixel_x - 5 - 15) + (pixel_y-w_ball_y-2)];
                    {red, green, blue} <= {cue_vert_pal[addr]};
                    cue_display <= 1;
                end
                else
                if (rot == 3 && pixel_x < w_ball_x-20 && 100+pixel_x >= (100+w_ball_x)-20-57 && pixel_y < w_ball_y-20 && 100+pixel_y >= (100+w_ball_y)-20-57)
                begin
                    addr = cue_diag[pixel_x-w_ball_x+20+57 + 57*(w_ball_y-pixel_y-20)];
                    {red, green, blue} <= {cue_diag_pal[addr]};
                    cue_display <= 1;
                end
                else
                if (rot == 4 && pixel_x >= w_ball_x-2 && pixel_x <= w_ball_x+2 && pixel_y <= w_ball_y-20 && (100+pixel_y) > (100+w_ball_y)-20-73)
                begin
                    addr = cue_vert[w_ball_x-pixel_x+2 + 5*(w_ball_y-20-pixel_y)];
                    {red, green, blue} <= {cue_vert_pal[addr]};
                    cue_display <= 1;
                end
                else
                if (rot == 5 && pixel_x > w_ball_x+20 && pixel_x <= w_ball_x+20+57 && pixel_y < w_ball_y-20 && (100+pixel_y) >= (100+w_ball_y)-20-57)
                begin                    
                    addr = cue_diag[w_ball_x+57-pixel_x+20 + 57*(w_ball_y-pixel_y-20)];
                    {red, green, blue} <= {cue_diag_pal[addr]};
                    cue_display <= 1;
                end
                else
                if (rot == 6 & pixel_x >= w_ball_x+20 & pixel_x < w_ball_x+20+73 & pixel_y >= w_ball_y-2 & pixel_y <= w_ball_y+2)
                begin
                    addr = cue_vert[5*(pixel_x - w_ball_x - 20) + (pixel_y-w_ball_y+2)];
                    {red, green, blue} <= {cue_vert_pal[addr]};
                    cue_display <= 1;
                end
                else
                if (rot == 7 && pixel_x > w_ball_x+20 && pixel_x <= w_ball_x+20+57 && pixel_y > w_ball_y+20 && pixel_y <= w_ball_y+20+57)
                begin                    
                    addr = cue_diag[w_ball_x+20+57-pixel_x + 57*(pixel_y-w_ball_y-21)];
                    {red, green, blue} <= {cue_diag_pal[addr]};
                    cue_display <= 1;
                end
                else
                begin
                    {red, green, blue} <= 12'h0;
                    cue_display <= 0;
                end
            end
        else
        begin
            {red, green, blue} <= 12'h0;
            cue_display <= 0;
        end
    end
    
    
endmodule
