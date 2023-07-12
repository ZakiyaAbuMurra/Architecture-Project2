						   // Code your testbench here
// or browse Examples
module data_mem_tb(); 	   
  // input = reg 
  // output = wire 
  reg memR, memW,clk; 
  reg [31:0] address, Din; 
  wire [31:0]Dout; 
  
  //insatnce DUT  
  DataMem DUT( .clk(clk), 
              .memR(memR), 
              .memW(memW), 
              .address(address), 
              .Din(Din),
              .Dout(Dout)
               ); 
  // initial input 
  initial begin 
	clk = 0 ;  
	memR =0 ; 
    memW =0 ; 
    Din = 'h0 ;   
	address = 'h0 ; 
  end 
  
  //generate clock 
   initial begin 
    forever begin 
      #3 clk <= ~clk ;
      end
  end
  
  
  initial begin 
    forever begin 
      #3 Din <= $urandom_range(0 , 32); 
      #6 address <= $urandom_range(0 , 2**10 -4);     
    end 
  end 
  
  initial begin
    forever begin
      repeat($urandom_range(1,5)) 
        @(posedge clk);
      memW <= 0;
	  memR <= 0;
      repeat($urandom_range(5,10)) 
        @(posedge clk);
      memR <= 0; 
	  memW <= 1;
      repeat ($urandom_range(5,10))
	  @(posedge clk);	
	  memR <= 1; 
	  memW <= 0;
	  repeat ($urandom_range(5,10))
        @(posedge clk);
    end
  end

  
    initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #1000
    $finish ; 
    end  
  
endmodule