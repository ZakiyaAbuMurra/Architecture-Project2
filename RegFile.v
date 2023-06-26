// Code your design here
module RegFile(RA, RB, RW ,Bus_A, Bus_B, Bus_W, clk ,reg_write);
	input clk,reg_write;
	input [4:0] RA,RB,RW;
	input [31:0] Bus_W;
	output wire [31:0] Bus_A, Bus_B;
	
	integer i=0;
	reg [31:0] register_file [31:0];	 
	
		initial	begin
			for(i=0;i<32; i=i+1)
				register_file[i]=0;	
		end
					
	always @(posedge clk) begin
	  if (reg_write) begin
	    register_file[RW] <= Bus_W;
	  end
      
//         foreach(register_file[i])begin 
//           $display(" %t , index[%0h] = %0h" ,$time , i , register_file[i] );
//       end  
	end	   
	
	 assign Bus_A =  register_file[RA];
     assign Bus_B =  register_file[RB];
	 
	
endmodule
