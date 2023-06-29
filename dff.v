module dff  #(parameter REG_WIDTH = 32)(d, clk , q) ;
	 input [REG_WIDTH-1 : 0 ]d;   
     input clk ;   
     output reg [REG_WIDTH-1 : 0 ]q;  
  
    always @ (posedge clk) begin 
			 q <= d;  

    end 
          
endmodule  