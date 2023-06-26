// Code your design here
module sign_extender (
    input [23:0] in,
    input signop,
    output reg [31:0] out
    );
    
    always @(*) begin
      integer i;
      if (signop) begin
        // signed extension
        for(i = 23; i < 32; i = i+1) begin
          out[i] = in[23];
        end
        out[23:0] = in;
      end else begin
        // unsigned extension
        for(i = 24; i < 32; i = i+1) begin
          out[i] = 1'b0;
        end
        out[23:0] = in;
      end
    end
  endmodule
  