// Code your testbench here
// or browse Examples
module control_tb(); 
   
	reg [1:0] inst_type;
	reg [4:0] inst_function;
	reg stop_bit, zero_flag; 
	reg [2:0] state;
	wire ExSrc, ExS, RS2src, WB, MemR, MemW, WBdata,  PCaddSrc1, PCaddSrc2, ALUsrc, StR, StW;
    wire [1:0] PCsrc ; 
	wire [3:0] ALUop; // 4 bit:: TODO: change
	wire[2:0] next_state; 
	
	
	ControlUnit DUT (	.inst_type(inst_type) , 
						.inst_function(inst_function), 
						.stop_bit(stop_bit), 
						.zero_flag(zero_flag), 
						.ExSrc(ExSrc), 
						.ExS(ExS), 
                        .state(state), 
						.RS2src(RS2src),
						.WB(WB),
						.MemR(MemR),
						.MemW(MemW),
						.WBdata(WBdata),
						.PCsrc(PCsrc),
						.PCaddSrc1(PCaddSrc1),
						.PCaddSrc2(PCaddSrc2), 
						.ALUsrc(ALUsrc),
						.StR(StR),
						.StW(StW),
						.ALUop(ALUop),
						.next_state(next_state)
	                ); 				     
					
					
	initial begin 
		inst_type     = 0 ; 
		inst_function = 0 ; 
		stop_bit	  = 0 ; 
		zero_flag 	  = 0 ; 
		state 		  = 2 ; 	
	end 					
	
	
// 	initial
// 	begin 
//       forever begin 
//         #10	inst_type     <= $urandom_range(0,3) ; 
//         #20 inst_function <= $urandom_range(0,3); 
//         #30 stop_bit	  <= $urandom_range(0,1) ; 
//         #35	zero_flag 	  <= $urandom_range(0,1) ; 
//         #10
//         state 		  <= $urandom_range(0,5) ; 
//       end 
// 	end	
  
  
	initial
	begin 
      forever begin 
        #10	inst_type     <= 10 ; 
        #20 inst_function <=5'b00100 ; 
        #30 stop_bit	  <= $urandom_range(0,1) ; 
        #35	zero_flag 	  <= $urandom_range(0,1) ; 
        #10
        state 		  <= $urandom_range(0,5) ; 
      end 
	end	
	
	
    initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #10000
    $finish ; 
    end  
	
endmodule
