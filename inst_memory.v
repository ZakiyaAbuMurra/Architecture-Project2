// Code your design here
module InstMem(address, Dout, Din, memW);  
	input wire memW = 0;
	input [31:0] address, Din;
	output wire [31:0] Dout;	 
	
	integer i=0;
	reg [7:0] inst_mem [2**10 -1 :0]; 
	
	initial	begin
		for(i=0;i < 2**10; i=i+1)
			inst_mem[i]=0;	
	end	
	
	always @* begin
  if (memW) begin
    inst_mem[address] <= Din[7:0];
    inst_mem[address+1] <= Din[15:8];
    inst_mem[address+2] <= Din[23:16];
    inst_mem[address+3] <= Din[31:24];
  end
end
	
   	assign Dout = {inst_mem[address+3],inst_mem[address+2],inst_mem[address+1],inst_mem[address]};
		 
endmodule