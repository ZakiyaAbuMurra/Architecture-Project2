module dff  #(parameter REG_WIDTH = 32)(Din_f , clk , Dout_f) ;
	 input [REG_WIDTH-1 : 0 ]Din_f;   
     input clk ;   
  output reg [REG_WIDTH-1 : 0 ]Dout_f  ;  
  initial Dout_f = 0;
    
    
 	// posedge clk
  always @ (*) begin 
			 Dout_f <= Din_f  ;  

    end 
          
endmodule  