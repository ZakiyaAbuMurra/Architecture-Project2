module mux_2x1 #(parameter DATA_WIDTH = 32)
    (
     input wire [DATA_WIDTH-1:0] data0,
     input wire [DATA_WIDTH-1:0] data1,
     input wire sel,
     output wire [DATA_WIDTH-1:0] out
    );
  
    assign out = (sel == 1'b0) ? data0 : data1;
  
  endmodule
  