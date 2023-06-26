module mux4x1 (	  
    input wire [1:0] sel,
      input wire [31:0] a,
      input wire [32:0] b,
      input wire [31:0] c,
      output reg [31:0] out
    );
    
    always @ (a or b or c or sel)
        begin
            case(sel)
            2'b00 : out = a;
            2'b01 : out = b;
            2'b10 : out = c;  
            endcase
        end
    endmodule