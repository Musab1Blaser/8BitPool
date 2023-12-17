`timescale 1ns / 1ps

module v_counter(clk, v_enable, v_count);
    input clk;
    output v_count;
    reg [9:0] v_count;
    input v_enable;
    initial
        v_count = 0;
        
    always @(posedge clk)
    begin
        if (v_enable)
        begin
            if (v_count < 524)
                begin
                    v_count <= v_count + 1;
//                if (h_count == 0)
//                    trig_v <= 0;
            end
            else
            begin
//               trig_v <= 1;
                v_count <= 0;
            end
        end
    end
endmodule
