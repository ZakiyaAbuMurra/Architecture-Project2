module adder( 
  input [32-1:0] in1 , in2  , 
  output reg  [32-1:0] out  
);
  assign out = in1 + in2 ; 
  
endmodule 