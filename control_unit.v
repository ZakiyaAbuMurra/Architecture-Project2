// Code your design here
module ControlUnit(inst_type, inst_function, stop_bit, zero_flag,
	ExSrc, ExS, RS2src, WB, MemR, MemW, WBdata,
	 PCaddSrc1, PCaddSrc2,
	ALUsrc, ALUop,
	StR, StW,PCsrc, 
	state, next_state);
	
	input [1:0] inst_type;
	input [4:0] inst_function;
	input stop_bit, zero_flag; 
	input [2:0] state;
	output reg ExSrc, ExS, RS2src, WB, MemR, MemW, WBdata, PCaddSrc1, PCaddSrc2, ALUsrc, StR, StW;
    output reg [1:0] PCsrc ; 
	output reg [3:0] ALUop; // 4 bit:: TODO: change
	output reg [2:0] next_state;
	
	parameter IF_STAGE = 0;
	parameter ID_STAGE = 1;
	parameter EX_STAGE = 2;
	parameter MEM_STAGE = 3;
	parameter WB_STAGE = 4;
	parameter ST_STAGE = 5;
	
	parameter R_TYPE = 2'b00;
	parameter I_TYPE = 2'b10;
	parameter J_TYPE = 2'b01;
	parameter S_TYPE = 2'b11;
	
	parameter ADD = 0;
	parameter SUB = 1;
	parameter AND = 2;
	parameter OR = 3;
	parameter XOR = 4;
	parameter SLL = 5;
	parameter SLR = 6;

	
	
	always@(state) begin
		case(state)
			IF_STAGE: begin
				next_state = ID_STAGE;
			end
			ID_STAGE: begin
				if(inst_type == J_TYPE && inst_function==0)begin // J
					next_state = IF_STAGE;
				end
				else if(inst_type == J_TYPE && inst_function==1) begin // Jal
					next_state = ST_STAGE;
				end
				else begin 
					next_state = EX_STAGE;
				end			
			end
			EX_STAGE: begin
				if (inst_type == R_TYPE || inst_type == S_TYPE) begin
					if(inst_type == R_TYPE && inst_function == 5'b00011) // CMP
						next_state = IF_STAGE;
					else 
						next_state = WB_STAGE;
				end
				else if (inst_type == R_TYPE) begin
					if(inst_function == 5'b0000x) // ANDI + ADDI
						next_state = WB_STAGE;
					else if (inst_function == 5'b0001x) // LW + SW
						next_state=MEM_STAGE;
					else if (inst_function == 5'b00100) // BEQ
						next_state = IF_STAGE;
				end
			end
			MEM_STAGE: begin
				if(inst_type == I_TYPE && inst_function == 5'b00010) // LW
					next_state = WB_STAGE;
				else // SW
					next_state = IF_STAGE;
			end
			
			WB_STAGE: begin
				next_state = IF_STAGE;
			end
			
			ST_STAGE: begin
				next_state = IF_STAGE;
			end
          
		endcase
		
		if(state!=ST_STAGE && next_state == IF_STAGE && stop_bit == 1) begin
			next_state = ST_STAGE;
		end
		else if(next_state== IF_STAGE) begin
			next_state = IF_STAGE;
		end
	end
	
	
	// main control signals
  always@ (inst_type, inst_function, state) begin
   
		casex({inst_type, inst_function})
			7'b0000011: begin // R-type: CMP 
				RS2src <= 0;  
				MemR <= 0;
				MemW <= 0;
				WB <=0;
			end
			
			7'b00000??: begin // R-type/CMP	
				RS2src <= 0;  
				MemR <= 0;
				MemW <= 0;
				WBdata <= 0;
				if(next_state == 4) begin
					WB <= 1;
				end		
			end
			
			7'b100000x: begin // I-type: ADDI + ANDI
				ExSrc <= 1;
				ExS <= 1;
				RS2src <= 0;
				MemR <= 0;
				MemW <= 0;
				WBdata <= 0;
				if(next_state == 4) begin
					WB <= 1;
				end	
			end
			
			7'b1000010: begin // I-type: LW
				ExSrc <= 1;
				ExS <= 1;
				RS2src <= 0;
				MemR <= 1;
				MemW <= 0;
				WBdata <= 1;
				if(next_state == 4) begin
					WB <= 1;
				end	
			end
			
			7'b1000011: begin // I-type: SW
				ExSrc <= 1;
				ExS <= 1;
				RS2src <= 1;
				WB <= 0;
				MemR <= 0;
				if(next_state == 3) begin
					MemW = 1;
				end	
			end
			
			7'b1000100: begin // I-type: BEQ
				ExSrc <= 1;
				ExS <= 1;
				RS2src <= 0;
				WB <= 0;
				MemR <= 0;	  
				MemW <= 0;
			end	
			
			7'b010000x:  begin // J-type
				WB <= 0;
				MemR <= 0;	  
				MemW <= 0;
			end	
			
			7'b110000x:  begin // S-type: SLL + SLR
				ExSrc <= 0;
				ExS <= 0;
				MemR <= 0;	  
				MemW <= 0;
				WBdata <= 0;
				if(next_state == 4) begin
					WB = 1;
				end	
			end	  
			
			7'b110001x:  begin // S-type: SLLV + SLRV
				RS2src <= 0;
				MemR <= 0;	  
				MemW <= 0;
				WBdata <= 0;
				if(next_state == 4) begin
					WB = 1;
				end	
			end	
		endcase
	end	
	
	
	// PC control
  always @(inst_type, inst_function, stop_bit, zero_flag, state , next_state) begin
		if(next_state == IF_STAGE) begin
			if (inst_type == R_TYPE || inst_type == S_TYPE)begin 
              if(stop_bit ==1) begin 
					PCsrc <= 0;
              end 
				else begin
					PCsrc <= 2;
                end 
			end
			else if(inst_type==I_TYPE) begin 
				if(stop_bit == 1)
					PCsrc <= 0;
				else if(inst_function == 5'b00100) begin // BEQ
					if(zero_flag == 1) begin
						PCsrc <= 1;
						PCaddSrc1 <= 1;	
						PCaddSrc2 <= 1;
					end 
					else
					   PCsrc <= 2;
				end
			end
			else if (inst_type == J_TYPE && inst_function == 5'b00000) begin // J
				if(stop_bit ==1)
					PCsrc <= 0;
				else begin
					PCsrc <= 1;
					PCaddSrc1 <= 0;	
					PCaddSrc2 <= 0;
				end
			end
			else begin // JAL
				PCsrc <= 1;
				PCaddSrc1 <= 0;	
				PCaddSrc2 <= 0;
			end
				
		end
    end 
  
    // ALU control signal 	
	always @(inst_type, inst_function) begin
		case({inst_type, inst_function})
			7'b0000000: begin // AND
				ALUsrc <= 0;
				ALUop <= AND;
			end	 
			
			7'b0000001: begin // ADD
				ALUsrc <= 0;
				ALUop <= ADD;
			end
			
			7'b0000010: begin // SUB
				ALUsrc <= 0;
				ALUop <= SUB;
			end
			
			7'b0000011: begin // CMP
				ALUsrc <= 0;
				ALUop <= SUB;
			end
			
			7'b1000000: begin // ANDI
				ALUsrc <= 1;
				ALUop <= AND;
			end
			
			7'b1000001: begin // ADDI
				ALUsrc <= 1;
				ALUop <= ADD;
			end
			
			7'b100001x: begin // LW + SW
				ALUsrc <= 1;
				ALUop <= ADD;
			end	 
			
			7'b1100000: begin // SLL
				ALUsrc <= 1;
				ALUop <= SLL;
			end	
			
			7'b1100001: begin // SLR
				ALUsrc <= 1;
				ALUop <= SLR;
			end
			
			7'b1100010: begin // SLLV
				ALUsrc <= 0;
				ALUop <= SLL;
			end	
			
			7'b1100011: begin // SLRV
				ALUsrc <= 0;
				ALUop <= SLR;
			end	
			
		endcase
		
	end
	
  // Stack control unit 
	always@(inst_type, inst_function, stop_bit, state) begin
      if (next_state == ST_STAGE)begin 
		if(inst_type == J_TYPE)begin
			if(inst_function == 5'b00000) begin
				if(stop_bit ==1) begin
					StR <= 1;
					StW <= 0;
				end	
				else begin
					StR <= 0;
					StW <= 0;
				end
			end	
			else begin
				StR <= 0;
				StW <= 1;
			end
		end
		
		else if (stop_bit == 0) begin 
		   	StR <= 0;
			StW <= 0;
		end
		else begin
			StR <= 1;
			StW <= 0;
		end
      end	
	end
	
	

endmodule		   
