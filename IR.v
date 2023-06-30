module IR(inst ,  inst_function , inst_rs1 , inst_rs2 , inst_rd ,  inst_type , stop_bit , imm_14 , imm_24 , inst_SA); 
	input      [32-1:0]   inst; 
	output reg [5-1:0] inst_function ; 
	output reg [5-1:0] inst_rs1 , inst_rs2 , inst_rd ;
	output reg [2-1:0] inst_type ; 
	output reg [5-1:0] inst_SA ;
	output reg [14-1:0] imm_14 ; 
	output reg [24-1:0] imm_24 ; 
	output reg stop_bit ; 
	
	parameter R_TYPE = 2'b00;
	parameter I_TYPE = 2'b10;
	parameter J_TYPE = 2'b01;
	parameter S_TYPE = 2'b11;
	
	always @(inst)
	begin 
		inst_type = inst[2:1] ; 	
		inst_function = inst[31:27]; 
		stop_bit = inst[0]; 
		if (inst_type == R_TYPE)begin 
			inst_rs1 = inst[26:22] ; 
			inst_rd = inst[21:17] ; 
			inst_rs2 = inst[16:12] ; 
		end    
		else if (inst_type == I_TYPE)begin 
			inst_rs1 = inst[26:22] ; 
			inst_rd = inst[21:17] ; 
			imm_14 = inst[16:3]; 
		end 
		else if (inst_type == J_TYPE)begin 
			imm_24 = inst[26:3] ; 
		end 					  
	    else begin 
		   	inst_rs1 = inst[26:22] ; 
			inst_rd = inst[21:17] ; 
			inst_rs2 = inst[16:12] ; 
			inst_SA = inst[11:7]; 
		end
	end	
	
	
	
endmodule