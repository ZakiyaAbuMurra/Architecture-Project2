															 						   // Code your testbench here
// or browse Examples
module inst_mem_tb(); 	   
  // input = reg 
  // output = wire 
  reg memW; 
  reg [31:0] address, Din; 
  wire [31:0]Dout; 
  
  //insatnce DUT  
  InstMem DUT(.memW(memW), 
              .address(address), 
              .Din(Din),
              .Dout(Dout)
               );  
  // initial input 
	  
	integer i=0;   
  
  integer k=0;
  initial begin
	  
	address<= 'h0;	
	Din <=0;
	memW<=1;
	for(i=0;i < 2**10; i=i+4) begin
		#1 Din <= {8'(i+3), 8'(i+2), 8'(i+1), 8'(i)};
		#1 address<=address+4;
	end
 	memW<=0;
	address<=0;
	
    forever begin
      #3 address <= k; // $urandom_range(0 , 2**10 -4); 
	  #6 k=k+1;
    end 
  end 

  
    initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #1000
    $finish ; 
    end  
  
endmodule
