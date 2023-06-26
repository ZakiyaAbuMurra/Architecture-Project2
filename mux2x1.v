module mux21 (
  input wire [23:0] a,
  input wire [23:0]b,
  input wire sel,
  output wire [23:0]out
);

assign out = sel ? b : a;

endmodule 