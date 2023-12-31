// Code your testbench here
// or browse Examples
module alu_tb() ; 
    // input = reg 
    // output = wire 
     reg [31:0]A ; 
     reg [31:0] B; 
  reg [2:0]opcode ;   // 4 bit opcode
     wire [31:0] result; 
     wire carry,zero,negative,overflow ;
     
     
     //instance the DUT 
     ALU DUT(.A(A), 
             .B(B), 
             .opcode(opcode),
             .result(result), 
             .carry(carry), 
             .zero(zero), 
             .overflow(overflow),
			 .negative(negative)
            );
     
     initial begin 
       forever begin 
         #3 A <= $urandom_range(0,255); 
         #6 B <= $urandom_range(0,255); 
         #12 opcode <= $urandom_range(0,4) ; 
   
       end 
     end 
     
      initial begin 
       $dumpfile("dump.vcd"); 
       $dumpvars;
       #1000 
       $finish ; 
       end  
     
     
     
   endmodule 