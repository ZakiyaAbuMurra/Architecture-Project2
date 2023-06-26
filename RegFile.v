module PC (
  input clk,
  input reset,
  input [31:0] pcIncrement,
  output reg [31:0] pcOut
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      pcOut <= 32'h0;  // Reset the PC to 0
    end
    else begin
      pcOut <= pcOut + pcIncrement;  // Increment the PC by pcIncrement
    end
  end

endmodule

*/