module extender_tb(); 
    reg [23:0] in;
    reg signop;
    wire [31:0] out;

    sign_extender dut (
      .in(in),
      .signop(signop),
      .out(out)
    );
    
    initial begin 
      in = 0; 
      signop =0 ; 
    end 
   
    
    initial begin 
      forever begin 
        #3 in <='hff2609 ;
        
        #6 signop <= $urandom_range(0,1) ; 
      end 
    end 
    
    
      initial begin 
      $dumpfile("dump.vcd"); 
      $dumpvars;
      #1000
      $finish ; 
      end  
    
    
  endmodule 