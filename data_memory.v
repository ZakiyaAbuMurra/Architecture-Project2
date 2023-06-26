// Code your design here
module DataMem(address, Din, Dout, memR, memW, clk);
	input  memR, memW,clk;
	input [31:0] address, Din;
	output wire [31:0] Dout;	 
	
	integer i=0;
	reg [7:0] data_mem [2**10 -1 :0]; 
	
	initial	begin
		for(i=0;i < 2**10; i=i+1)
			data_mem[i]=0;	
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