// Code your design here
module stack (
    input wire clk,
    input wire read_en,
    input wire write_en,
    input wire [31:0] data_in,
    output reg [31:0] data_out
    );
    parameter DEPTH = 16;
    
    reg [31:0] stack_storage [0:DEPTH-1];
    
    reg [4:0] sp = 0;
    // array عاملة حالها ستاك 
    always @(posedge clk) begin
    if (write_en && sp < DEPTH) begin
        stack_storage[sp] <= data_in;
        sp <= sp + 1;
    end
    
    if (read_en && sp > 0) begin
        sp <= sp - 1;
        data_out <= stack_storage[sp];
    end
    end
endmodule
