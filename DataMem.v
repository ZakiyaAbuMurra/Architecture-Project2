// Code your design here
module DataMem(address, Din, Dout, memR, memW, clk);
	input  memR, memW,clk;
	input [31:0] address, Din;
	output reg [31:0] Dout;	 
	
	integer i=0;
	reg [7:0] data_mem [2**10 -1 :0]; 
	
	initial	begin
    // int a = 2; 0x0002 // address = 0
      data_mem[0] = 'h02 ;
      data_mem[1] = 'h00 ;
      data_mem[2] = 'h00;
      data_mem[3] = 'h00;
	
	// int b = 1; 0x0001 // address = 4
      data_mem[4] = 'h01;
      data_mem[5] = 'h00;
      data_mem[6] = 'h00;
      data_mem[7] = 'h00;
	
	// int result = 0; 0x0000 // address = 8
      data_mem[8] = 'h00;
      data_mem[9] = 'h00;
      data_mem[10] = 'h00;
      data_mem[11] = 'h00;
	end
	
	
	
	always @(posedge clk) begin
		if(memW)begin
			data_mem[address] <= Din[7:0];
    		data_mem[address+1] <= Din[15:8];
    		data_mem[address+2] <= Din[23:16];
    		data_mem[address+3] <= Din[31:24];
		end	
	end
		

   	assign Dout = (memR) ? {data_mem[address+3],data_mem[address+2],data_mem[address+1],data_mem[address]} : 32'hzzzzzzzz;
		 
endmodule