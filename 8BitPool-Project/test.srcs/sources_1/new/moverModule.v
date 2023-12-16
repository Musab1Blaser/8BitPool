`timescale 1ns / 1ps

module moverModule(
    input v_sync,
    input cue_on,
    input [10:0] x_i,
    input [10:0]  y_i,
    input [4:0] u_x,
    input [4:0] u_y,
    input hit,
    input [2:0] rot,
    output reg [10:0] x_f,
    output reg [10:0] y_f,
    output reg [4:0] v_x,
    output reg [4:0] v_y,
    output reg [6:0] strength
    );
    
//    reg flag = 0;
    localparam MIN_X = 55;
    localparam MAX_X = 585;
    localparam MIN_Y = 75;
    localparam MAX_Y = 405;
    
//    assign cue_on = (v_x[3:0] == 0 && v_y[3:0] == 0);
    
    reg [3:0] counterX;
    reg [3:0] counterY;
//    reg [3:0] strength;
    
    initial
    begin
        counterX = 0;
        counterY = 0;
        strength = 0;
    end
    
//    always @(posedge hit)

//    always @(posedge v_sync)
//        if (counterX == 15)
//            flag = 1;    
    
    always @(posedge v_sync)
    begin
        if (u_x[4] == 0 && MIN_X <= x_i + u_x[3:0] && x_i + u_x[3:0] <= MAX_X)
            x_f <= x_i + u_x[3:0];
            
        else if (u_x[4] == 1 && MIN_X <= x_i - u_x[3:0] && x_i - u_x[3:0] <= MAX_X)
            x_f <= x_i - u_x[3:0];
            
        else if (y_i > MAX_Y)
            x_f <= x_i;
            
                       
                          
        if (u_y[4] == 0 && MIN_Y <= y_i + u_y[3:0] && y_i + u_y[3:0] <= MAX_Y)
            y_f <= y_i + u_y[3:0];
            
        else if (u_y[4] == 1 && MIN_Y <= y_i - u_y[3:0] && y_i - u_y[3:0] <= MAX_Y)
            y_f <= y_i - u_y[3:0];
            
        else if (y_i > MAX_Y)
            y_f <= y_i;
            
        
        if (u_x[4] == 0 && u_x[3:0] >= 1) 
        begin
            if (x_i + u_x[3:0] <= MAX_X)
                v_x = u_x;
                
            else
            begin
                v_x[4] = 1;
                v_x[3:0] = u_x[3:0];
            end
            
            if (counterX < 15) 
                counterX = counterX + 1;
            else
            begin
                counterX = 0;
                v_x[3:0] = v_x[3:0] - 1;
            end
            
//            if (u_x[3:0] < 15)
//                v_x[3:0] = u_x[3:0] + 1;
//            else
//                v_x[3:0] = 1;
                
        end   
        
        else if (u_x[4] == 1 && u_x[3:0] >= 1)
        begin
            if (MIN_X <= x_i - u_x[3:0])
                v_x = u_x;
                
            else 
            begin
                v_x[4] = 0;
                v_x[3:0] = u_x[3:0];
            end
            
            if (counterX < 15) 
                counterX = counterX + 1;
            else
            begin
                counterX = 0;
                v_x[3:0] = v_x[3:0] - 1;
            end
            
//            if (u_x[3:0] < 15)
//                v_x[3:0] = u_x[3:0] + 1;
//            else
//                v_x[3:0] = 1;
                
        end
        
        else if (u_x[3:0] == 0) // not having this makes it glitch
        begin
            v_x[4] = 0;
            v_x[3:0] = u_x[3:0];
        end
            
            
        if (u_y[4] == 0 && u_y[3:0] >= 1) 
        begin
            if (y_i + u_y[3:0] <= MAX_Y)
                v_y = u_y;
                
            else
            begin
                v_y[4] = 1;
                v_y[3:0] = u_y[3:0];
            end
            
            if (counterY < 15) 
                counterY = counterY + 1;
            else
            begin
                counterY = 0;
                v_y[3:0] = v_y[3:0] - 1;
            end
            
//            if (u_y[3:0] < 15)
//                v_y[3:0] = u_y[3:0] + 1;
//            else
//                v_y[3:0] = 1;
                
        end   
        
        else if (u_y[4] == 1 && u_y[3:0] >= 1)
        begin
            if (MIN_Y <= y_i - u_y[3:0])
                v_y = u_y;
                
            else 
            begin
                v_y[4] = 0;
                v_y[3:0] = u_y[3:0];
            end
            
            if (counterY < 15) 
                counterY = counterY + 1;
            else
            begin
                counterY = 0;
                v_y[3:0] = v_y[3:0] - 1;
            end
            
//            if (u_y[3:0] < 15)
//                v_y[3:0] = u_y[3:0] + 1;
//            else
//                v_y[3:0] = 1;
                
        end
        
        
        else if (u_y[3:0] == 0) // not having this makes it glitch
        begin
            v_y[4] = 0;
            v_y[3:0] = u_y[3:0];
        end
        if (cue_on)
        begin
            if (hit)
                begin 
                if (strength < 127)
                    strength = strength + 1;
                else
                    strength = 8;
                end
            else if (strength > 0)
            begin         
                if (rot == 0)
                    v_y = {1'b1, strength[6:3]};
                else if (rot == 1)
                    {v_x, v_y} = {1'b0, strength[6:3], 1'b1, strength[6:3]};
                else if (rot == 2)
                    v_x = {1'b0, strength[6:3]};
                else if (rot == 3)
                    {v_x, v_y} = {1'b0, strength[6:3], 1'b0, strength[6:3]};
                else if (rot == 4)
                    v_y = {1'b0, strength[6:3]};
                else if (rot == 5)
                    {v_x, v_y} = {1'b1, strength[6:3], 1'b0, strength[6:3]};
                else if (rot == 6)
                    v_x = {1'b1, strength[6:3]};
                else if (rot == 7)
                    {v_x, v_y} = {1'b1, strength[6:3], 1'b1, strength[6:3]};
                strength = 0;
            end
        end
//            v_x[3:0] = 15;
//            v_y[3:0] = 15;
        
       
        
//        if (v_x[3:0] < 15)
//                v_x = v_x + 1;
//             else
//                v_x = 1;
                 
//       if (v_y[3:0] < 15)
//                v_y = v_y + 1;
//             else
//                v_y = 1; 
  
 
    end
//    begin 
//        if (u_x[4] == 0)
//        begin
//            if (MIN_X <= x_i + u_x[3:0] && x_i + u_x[3:0] <= MAX_X)
//                x_f = x_i + u_x[3:0];
//            else
////                x_f = x_i - u_x[3:0];
//                x_f = 300;
//        end
//        else if (u_x[4] == 1)
//        begin
//            if (MIN_X <= x_i - u_x[3:0] && x_i - u_x[3:0] <= MAX_X)
//                x_f = x_i - u_x[3:0];
//            else 
////                x_f = x_i + u_x[3:0];
//                x_f = 300;
//        end
                          
//        if (u_y[4] == 0)
//        begin
//            if (MIN_Y <= y_i + u_y[3:0] && y_i + u_y[3:0] <= MAX_Y)
//                y_f = y_i + u_y[3:0];
//            else
////                y_f = y_i - u_y[3:0];
//                y_f = 200;
//        end
//        else if (u_y[4] == 1)
//        begin
//            if (MIN_Y <= y_i - u_y[3:0] && y_i - u_y[3:0] <= MAX_Y)
//                y_f = y_i - u_y[3:0];
//            else 
////                y_f = y_i + u_y[3:0];
//                y_f = 200;
//        end
        
//        if (u_x[4] == 0 && u_x[3:0] != 0) 
//        begin
//            if (x_i + u_x[3:0] <= MAX_X) // don't need to check if greater than MIN_X because it should never be the case when velocity is positive
////                v_x <= u_x - 1;
//                v_x = u_x;
//            else
//                begin
////                v_x <= (-1*u_x) + 1;
//                    v_x[4] = 1;
//                    v_x[3:0] = u_x[3:0];
//                end
//        end   
//        else if (u_x[4] == 1 && u_x[3:0] != 0)
//        begin
//            if (MIN_X <= x_i - u_x[3:0])
////                v_x <= u_x + 1;
//                v_x = u_x;
//            else 
//            begin
////                v_x <= (-1*u_x) - 1;
//                    v_x[4] = 0;
//                    v_x[3:0] = u_x[3:0];
//            end
//        end
//        else
//            v_x = 1;
            
//        if (u_y[4] == 0 && u_y[3:0] != 0) 
//        begin
//            if (y_i + u_y[3:0] <= MAX_Y) // don't need to check if greater than MIN_X because it should never be the case when velocity is positive
////                v_y <= u_y - 1;
//                v_y = u_y;
//            else
//                begin
////                v_y <= (-1*u_y) + 1;
//                    v_y[4] = 1;
//                    v_y[3:0] = u_y[3:0];
//                end
//        end   
//        else if (u_y[4] == 1 && u_y[3:0] != 0)
//        begin
//            if (MIN_Y <= y_i - u_y[3:0])
////                v_y <= u_y + 1;
//                v_y = u_y;
//            else 
//            begin
////                v_y <= (-1*u_y) - 1;
//                    v_y[4] = 0;
//                    v_y[3:0] = u_y[3:0];
//            end
//        end
//        else
//            v_y = 1;
        
//    end
    
endmodule
