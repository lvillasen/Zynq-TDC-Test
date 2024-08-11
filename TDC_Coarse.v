module TDC_Coarse (
    input wire clk,          
    input wire start,        
    input wire stop,         
    output reg [31:0] coarse_time 
    );


    reg [31:0] coarse_counter;

    reg start_detected;
    reg stop_detected;

  
    always @(posedge clk or posedge start or posedge stop) begin
        if (start) begin
            coarse_counter <= 0;
            start_detected <= 1;
            stop_detected <= 0;
        end else if (stop) begin
            if (start_detected) begin
                coarse_time <= coarse_counter;
                stop_detected <= 1;
            end
        end else if (start_detected && !stop_detected) begin
            coarse_counter <= coarse_counter + 1;
        end
    end

    

endmodule
