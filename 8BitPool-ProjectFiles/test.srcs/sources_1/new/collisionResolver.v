`timescale 1ns / 1ps

module collisionResolver(input clk, input cue_on, input myFlag,
input [10:0] x_f, input [10:0] y_f, input [4:0] v_x, input [4:0] v_y, 
input [10:0] rx_f, input [10:0] ry_f, input [4:0] rv_x, input [4:0] rv_y, 
output reg [4:0] v_x2, output reg [4:0] v_y2, output reg [4:0] rv_x2, output reg [4:0] rv_y2
, output reg [2:0] nextFlag
    );
    
    localparam radius = 15;
    
//    reg [4:0] flag; // for clock delay - otherwise flickering as updates made on same cycle as moverModule
    
    initial
    begin
//        flag <= 0;
        nextFlag <= 0;
        v_x2 <= 0;
        v_y2 <= 0;
        rv_x2 <= 0;
        rv_y2 <= 0;
//        led1 <= 0;
    end
    
    always @(posedge clk)
    begin // after vsync posedge - so if vsync - is on and flag = 1
        if (~myFlag)
            nextFlag <= 0;
        else 
        if (nextFlag < 2)
            nextFlag <= nextFlag + 1;
    end
            
    always @(posedge myFlag)
    begin
//                led1 <= 0;
        v_x2 <= v_x;
        v_y2 <= v_y;
        rv_x2 <= rv_x;
        rv_y2 <= rv_y;
                
        if (((x_f-rx_f)*(x_f-rx_f) + (y_f-ry_f)*(y_f-ry_f)) <= 4*radius*radius & ~cue_on)
        begin
//                    led1 <= 1;
            if (v_x[3:0] == 0 && v_y[3:0] == 0 && rv_x[3:0] == 0 && rv_y[3:0] == 0)
            begin
//                v_x2 <= 3;
//                v_y2 <= 3;
//                rv_x2 <= 19;
//                rv_y2 <= 19; 
                if (x_f < rx_f)
                begin
                    v_x2 <= 19;
                    rv_x2 <= 3;
                end
                else
                begin
                    v_x2 <= 3;
                    rv_x2 <= 19;
                end    
                
                if (y_f < ry_f)
                begin
                    v_y2 <= 19;
                    rv_y2 <= 3;
                end
                else
                begin
                    v_y2 <= 3;
                    rv_y2 <= 19;
                end    
                    
            end         
            else
            begin
            // exchange velocities on collision
            
//                v_x2[4] = rv_x2[4];
//                v_y2[4] = rv_y2[4];
//                rv_x2[4] = v_x2[4];
//                rv_y2[4] = v_y2[4];
                
//                if (rv_x[3:0] > 2)
//                    v_x2[3:0] <= rv_x[3:0] - 2;
//                else 
//                    v_x2[3:0] = 0;
                    
                
//                if (rv_y[3:0] > 2)
//                    v_y2[3:0] <= rv_y[3:0] - 2;
//                else 
//                    v_y2[3:0] = 0;    
                    
//                if (v_x[3:0] > 2)
//                    rv_x2[3:0] <= v_x[3:0] - 2;
//                else 
//                    rv_x2[3:0] = 0;
                    
                
//                if (v_y[3:0] > 2)
//                    rv_y2[3:0] <= v_y[3:0] - 2;
//                else 
//                    rv_y2[3:0] = 0;        
                    
                v_x2 <= rv_x;
                v_y2 <= rv_y;
                  
                rv_x2 <= v_x;
                rv_y2 <= v_y;
            end
        end
    end
    
endmodule
