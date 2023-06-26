// Code your testbench here
// or browse Examples
module tb(); 
  // input = reg 
  // output = wire 
  reg clk , reg_write ; 
  reg [4:0] RA,RB,RW; 
  reg [31:0] Bus_W; 
  wire [31:0] Bus_A, Bus_B; 
  
  //insatnce DUT  
  RegFile DUT( .clk(clk), 
              .RA(RA), 
              .RB(RB), 
              .RW(RW), 
              .Bus_W(Bus_W),
              .Bus_A(Bus_A), 
              .Bus_B(Bus_B) , 
              .reg_write(reg_write)
               ); 
  // initial input 
  initial begin 
    clk = 0 ; 
    reg_write =0 ; 
    RA = 'h0 ; 
    RB = 'h0 ; 
    RW = 'h0 ; 
    Bus_W = 'h0  ; 
  end 
  
  //generate clock 
   initial begin 
    forever begin 
      #3 clk <= ~clk ;
      end
  end
  
  
  initial begin 
    forever begin 
      #3 RA <= $urandom_range(0 , 32); 
      #6 RB <= $urandom_range(0 , 32); 
      #9 RW<= $urandom_range(0 , 32); 
      #12 Bus_W <= $urandom_range(0 , 255);
    
    end 
  end 
  
  initial begin
    forever begin
      repeat($urandom_range(1,5)) 
        @(posedge clk);
      reg_write <= ~reg_write ;
      repeat($urandom_range(500,1000)) 
        @(posedge clk);
      reg_write <= ~reg_write ; 
      repeat ($urandom_range(3000,5000))
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
