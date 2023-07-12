module cpu( 
  input clk ,
  input [31:0] inst_Din
); 
  
  	
	parameter IF_STAGE = 'b000;
	parameter ID_STAGE = 'b001;
	parameter EX_STAGE = 'b010;
	parameter MEM_STAGE ='b011;
	parameter WB_STAGE = 'b100;
	parameter ST_STAGE = 'b101;
  
  	
	parameter R_TYPE = 2'b00;
	parameter I_TYPE = 2'b10;
	parameter J_TYPE = 2'b01;
	parameter S_TYPE = 2'b11 ;
  
  
  reg [32-1:0] pc_next_out , pc_next_in ;
  reg [32-1:0] pc_BTA_J_out , pc_BTA_J_in; 
  reg [32-1:0] pc_stack_in , pc_stack_out ; 
  reg [2-1:0] PCsrc; 
  reg [32-1:0]pc_in , pc_out; 
  
  
  reg PCaddSrc1 , PCaddSrc2 ;  
  reg [32-1:0] unnamed1 , unnamed2 ; 
  
  reg [32-1:0] ext_reg_in , ext_reg_out ; 
  reg [32-1:0] inst_mem_out;

  reg StR, StW;
  
  reg [5-1:0] inst_function ; 
  reg [5-1:0] inst_rs1 , inst_rs2 , inst_rd ;
  reg [2-1:0] inst_type ; 
  reg [5-1:0] inst_SA ;
  reg [14-1:0] imm_14 ; 
  reg [24-1:0] imm_24 ; 
  reg stop_bit ; 
  reg [2-1:0] EXsrc ;
  reg[32-1:0] ext_in;
  reg EXs;
  
  reg [5-1:0] mux_src_rf_out;
  reg RS2src;
  
  reg [32-1:0] S1Bus_in, S1Bus_out;
  reg [32-1:0] S2Bus_in, S2Bus_out;
  reg [32-1:0] WBUS;
  reg WB_en;
  
  reg [32-1:0] ALU_res_in, ALU_res_out;
  reg [32-1:0] D_mem_reg_in, D_mem_reg_out;
  reg [4-1:0] ALU_flags_in, ALU_flags_out; // 0:carry  1:zero  2:negative  3:overflow
  
  reg WBdata;
  
  reg [32-1:0] mux_src_ALU_out;
  
  reg ALUsrc;
  
  reg [3-1:0] ALUop;
  
  reg memR, memW;
  
  reg [3-1:0] state =0, next_state=0;
  
//   initial begin
//     state <= 0;
//     next_state <= 0 ; 
//   end 
  int i =0; 
  always @(negedge clk)begin 
    if (i <1 )begin 
      i  ++ ; 
//      state <=0; 
   end 
   else begin 
       state <=  next_state ;
   end 
    // $display("State = %0d , next_state = %0d " , state , next_state);
 end 
  
  always @(*)begin
      case (state)
        IF_STAGE: begin
            // Define FETCH behavior here...
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
              else if (inst_type == I_TYPE) begin
                if(inst_function == 5'b00001 ||(inst_function == 5'b00000)) begin // ANDI + ADDI
						next_state = WB_STAGE;
                end 
                else if ((inst_function == 5'b00011) || (inst_function == 5'b00010)) // LW + SW
						next_state=MEM_STAGE;
					else if (inst_function == 5'b00100) // BEQ
						next_state = IF_STAGE;
				end
        
        end
        WB_STAGE: begin
            next_state =IF_STAGE;
        end
        MEM_STAGE : begin 
          if(inst_type == I_TYPE && inst_function == 5'b00010) // LW
					next_state = WB_STAGE;
				else // SW
					next_state = IF_STAGE;
       
        end 
        ST_STAGE: begin 
           next_state = IF_STAGE ; 
        end 
        default: begin
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

  
  ControlUnit CU(.clk(clk),
                 .inst_type(inst_type),
                 .inst_function(inst_function), 
                 .stop_bit(stop_bit),
                 .zero_flag(ALU_flags_out[1]),
                 .ExSrc(EXsrc),
                 .ExS(EXs),
                 .RS2src(RS2src), 
                 .WB(WB_en), 
                 .MemR(memR),
                 .MemW(memW), 
                 .WBdata(WBdata),
                 .PCaddSrc1(PCaddSrc1),
                 .PCaddSrc2(PCaddSrc2),
                 .ALUsrc(ALUsrc), 
                 .ALUop(ALUop),
                 .StR(StR), 
                 .StW(StW),
                 .PCsrc(PCsrc), 
                 .state(state),
                 .next_state(next_state));
  
  
  
  
  dff #(32)reg_next_pc (.Din_f(pc_next_in) , .clk(clk) , .Dout_f(pc_next_out));
  dff #(32)reg_BTA_J(.Din_f(pc_BTA_J_in) , .clk(clk) , .Dout_f(pc_BTA_J_out) );
  dff #(32)reg_stack_pc (.Din_f(pc_stack_in) , .clk(clk),.Dout_f(pc_stack_out));
  
  mux4x1 mux_pc (.sel(PCsrc), .a(pc_stack_out) , .b(pc_BTA_J_out) , .c(pc_next_out) ,.out(pc_in)) ;
  pc pc_u (.clk(clk) , .pc_out(pc_out) ,.pc_in(pc_in) ,.state(state) );
  
  adder add_pc_next(.in1(pc_out) , .in2(4) , .out(pc_next_in)); 
  
  mux_2x1 mux_BTA_J_1 (.data0(pc_out) , .data1(pc_next_out) , .out(unnamed1) , .sel(PCaddSrc1));
  mux_2x1 mux_BTA_J_2 (.data0(ext_reg_out) , .data1(ext_reg_out << 2 ) , .out(unnamed2) , .sel(PCaddSrc2));
  
  adder add_pc_BTA_J (.in1(unnamed1) , .in2(unnamed2) , .out(pc_BTA_J_in));
  
  stack stack_u(.data_in(pc_next_out), .data_out(pc_stack_in), .write_en(StW), .read_en(StR), .clk(clk));
  
  
  InstMem inst_mem(.memW(0), .Dout(inst_mem_out), .address(pc_out));
  
  IR (.clk(clk) , .inst(inst_mem_out) ,  .inst_function(inst_function) , .inst_rs1(inst_rs1) , .inst_rs2(inst_rs2) , .inst_rd(inst_rd) , .inst_type(inst_type) , .stop_bit(stop_bit) , .imm_14(imm_14) , .imm_24(imm_24) , .inst_SA(inst_SA));
  
  mux4x1 mux_ext (.sel(EXsrc), .a(inst_SA) , .b(imm_14) , .c(imm_24) ,.out(ext_in)) ;
  
  sign_extender extender(.in(ext_in), .signop(EXs), .EXsrc(EXsrc), .out(ext_reg_in));
  
  mux_2x1#(5) mux_src_rf (.data0(inst_rs2) , .data1(inst_rd) , .out(mux_src_rf_out) , .sel(RS2src));
  
  RegFile RF(.RA(inst_rs1), .RB(mux_src_rf_out), .RW(inst_rd), .Bus_A(S1Bus_in), .Bus_B(S2Bus_in), .Bus_W(WBUS), .clk(clk), .reg_write(WB_en));

    
  dff #(32)reg_S1Bus(.Din_f(S1Bus_in) , .clk(clk) , .Dout_f(S1Bus_out));
  dff #(32)reg_S2Bus(.Din_f(S2Bus_in) , .clk(clk) , .Dout_f(S2Bus_out));
  
  mux_2x1  mux_rf_wb(.data0(ALU_res_out) , .data1(D_mem_reg_out) , .out(WBUS) , .sel(WBdata));

  mux_2x1  mux_src_ALU(.data0(S2Bus_out) , .data1(ext_reg_out) , .out(mux_src_ALU_out) , .sel(ALUsrc));
  
  ALU ALU_u(.A(S1Bus_out), .B(mux_src_ALU_out), .opcode(ALUop), .result(ALU_res_in), .carry(ALU_flags_in[0]), .zero(ALU_flags_in[1]), .negative(ALU_flags_in[2]), .overflow(ALU_flags_in[3]));

  
  DataMem data_mem(.address(ALU_res_out), .Din(S2Bus_out), .Dout(D_mem_reg_in), .memR(memR), .memW(memW), .clk(clk));
  
  
  
  dff #(32)reg_extend(.Din_f(ext_reg_in) , .clk(clk) , .Dout_f(ext_reg_out));

  dff #(4)reg_AluFlag (.Din_f(ALU_flags_in), .clk(clk) , .Dout_f(ALU_flags_out) );
  dff #(32)reg_AluResult(.Din_f(ALU_res_in), .clk(clk), .Dout_f(ALU_res_out) );
  
  
  dff #(32)reg_DataMem(.Din_f(D_mem_reg_in), .clk(clk) , .Dout_f(D_mem_reg_out)) ;  
  
  
endmodule 