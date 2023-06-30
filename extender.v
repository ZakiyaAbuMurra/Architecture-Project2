// Code your design here
module sign_extender (
    input [32-1:0] in,
    input signop,
	input EXsrc, 
    output reg [32-1:0] out
    );
	
	
    
    always @(*) begin
      integer i;
	  integer j ; 
	  if(EXsrc == 0 )begin 
		  j = 5 ; 
	  end 
	  else if (EXsrc == 1 )begin 
		  j =14 ; 
      end 		  
	  else begin 
		 j = 24 ; 
	  end
      for(i = 0; i < j; i = i+1) begin
              out[i] = in[i];
      end	
      if (signop) begin
         //signed extension	
	    for(i = j ; i <32 ; i = i+1 )
              out = in[j-1];
        end
	  else begin
        // unsigned extension
        for(i = j; i < 32; i = i+1) begin
          out[i] = 1'b0;
        end	
	  end 
    end	
  endmodule
  