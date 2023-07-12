// Code your design here
module ControlUnit(clk , inst_type, inst_function, stop_bit, zero_flag,
	ExSrc, ExS, RS2src, WB, MemR, MemW, WBdata,
	 PCaddSrc1, PCaddSrc2, next_state , 
	ALUsrc, ALUop,
	StR, StW,PCsrc, 
	state);
  
  
	input clk ; 
  	input [1:0] inst_type;
  	input [4:0] inst_function;
	input stop_bit, zero_flag; 
	input [2:0] state;
	output reg  ExS =0 , RS2src =0 , WB=0 , MemR =0 , MemW =0 , WBdata =0 , PCaddSrc1 =0 , PCaddSrc2 =0 , ALUsrc =0               , StR =0 , StW =0 ;
    output reg [1:0] ExSrc ; 
    output reg [1:0] PCsrc = 'b10 ; 

    output reg [2:0] ALUop = 0 ; 
  input [2:0] next_state ; 
	
	parameter IF_STAGE = 'b000;
	parameter ID_STAGE = 'b001;
	parameter EX_STAGE = 'b010;
	parameter MEM_STAGE ='b011;
	parameter WB_STAGE = 'b100;
	parameter ST_STAGE = 'b101;
	
	parameter R_TYPE = 2'b00;
	parameter I_TYPE = 2'b10;
	parameter J_TYPE = 2'b01;
	parameter S_TYPE = 2'b11;
	
	//return here 
	parameter ADD = 0;
	parameter SUB = 1;
	parameter AND = 2;
	parameter SLL = 3;
	parameter SLR = 4;
	
	
	// main control signals
  always@ (negedge clk) begin 
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
              	else begin
                  WB <= 0;
                end
			end
			
			7'b100000?: begin // I-type: ADDI + ANDI
				ExSrc <= 1;
				ExS <= 1;
				MemR <= 0;
				MemW <= 0;
				WBdata <= 0;
				if(next_state == 4) begin
					WB <= 1;
				end	
              	else begin
                  WB <= 0;
                end
			end
			
			7'b1000010: begin // I-type: LW
				ExSrc <= 1;
				ExS <= 1;
				MemR <= 1;
				MemW <= 0;
				WBdata <= 1;
				if(next_state == 4) begin
					WB <= 1;
				end
              	else begin
                  WB <= 0;
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
              	else begin
                  MemW <= 0;
                end
			end
			
			7'b1000100: begin // I-type: BEQ
				ExSrc <= 1;
				ExS <= 1;
				RS2src <= 1;
				WB <= 0;
				MemR <= 0;	  
				MemW <= 0;
			end	
			
			7'b010000?:  begin // J-type
				WB <= 0;
				MemR <= 0;	  
				MemW <= 0;
              	ExSrc <= 2;
              	ExS <= 1;

			end	
			
			7'b110000?:  begin // S-type: SLL + SLR
				ExSrc <= 0;
				ExS <= 0;
				MemR <= 0;	  
				MemW <= 0;
				WBdata <= 0;
				if(next_state == 4) begin
					WB = 1;
				end	
              	else begin
                  WB <= 0;
                end
			end	  
			
			7'b110001?:  begin // S-type: SLLV + SLRV
				RS2src <= 0;
				MemR <= 0;	  
				MemW <= 0;
				WBdata <= 0;
				if(next_state == 4) begin
					WB = 1;
				end	
              	else begin
                  WB <= 0;
                end
			end	
		endcase
	end	
	
	
	// PC control
  always @(negedge clk) begin // TODO: posedge
		if(next_state == IF_STAGE) begin
			if (inst_type == R_TYPE || inst_type == S_TYPE)begin 
              if(stop_bit ==1) begin 
					PCsrc <= 0;
              end // stop bit =1 
				else begin
					PCsrc <= 2;
                end 
			end // R-type , s 
			else if(inst_type==I_TYPE) begin 
				if(stop_bit == 1)
					PCsrc <= 0;
				else if(inst_function == 5'b00100) begin // BEQ
					if(zero_flag == 1) begin
						PCsrc <= 1;
						PCaddSrc1 <= 1;	
						PCaddSrc2 <= 1;
					end //zero flag 
				    else
					   PCsrc <= 2;
                end 
              else begin 
                PCsrc <=2 ; 
              end 
				
			end // I-type 
			else if (inst_type == J_TYPE && inst_function == 5'b00000) begin // J
              
				if(stop_bit ==1)
					PCsrc <= 0;
				else begin
					PCsrc <= 1;
					PCaddSrc1 <= 0;	
					PCaddSrc2 <= 0;
				end
			end // j type  block 
            else if (inst_type == J_TYPE && inst_function == 5'b00001) begin // JAL
              $display("-------------------------------------------");
				PCsrc <= 1;
				PCaddSrc1 <= 0;	
				PCaddSrc2 <= 0;
			end // jal 
          
            else begin
              PCsrc <= 2;
            end
				
		end
    end 
  
  
    // ALU control signal 	//  , inst_type, inst_function
  always @(posedge clk, inst_type, inst_function) begin
		casex({inst_type, inst_function})
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
          
          	7'b1000100: begin // BEQ
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
			
			7'b100001?: begin // LW + SW
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
  always@(negedge clk) begin
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
    else begin 
      StR =0 ; 
      StW =0  ;
    end 
	end
	
	

endmodule		   
