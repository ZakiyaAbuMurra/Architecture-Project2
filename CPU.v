module CPU(clk, inst_Din);
	input clk;
	input [31:0] inst_Din;
	
	reg [31:0] next_pc0, next_pc1, next_pc2;
	wire [31:0] pc_value; 
	wire [1:0] inst_type ; 
	wire [1:0] [4:0] inst_function; 
	wire stop_bit ; 
	reg ExS, RS2src, WB, MemR, MemW, WBdata, PCaddSrc1, PCaddSrc2, ALUsrc, StR, StW;  
	reg [2-1:0] ExSrc ; 
	reg [1:0] PCsrc ; 
	reg [2:0] ALUop; 
	
	wire [2:0] next_state; 
	
    //stack wires 
	wire [31:0] St_Din; 
	reg [31:0] St_Dout; 
	// instruction memory wires 
	wire inst_mem_output ; 
	
	
	//IR wires 
	wire [5-1:0] RS1 ; 
	wire [5-1:0] RS2 ;	 
	wire [5-1:0] RD  ; 
	wire [5-1:0] inst_function_w ; 
	wire [2-1:0] inst_type_w ; 
	wire [14-1:0] imm14_w ; 
	wire [24-1:0] imm24_w ; 
	wire [5-1:0] inst_SA_w; 

	//RF wires 
	reg [32-1:0] S1Bus ; 
	reg [32-1:0] S2Bus ; 
	wire [32-1:0] WBus  ; 	
	
	//extender wires 
	wire [32-1:0] mux_ext_out; 
	reg [32-1:0] ext_out ; 
	
	//ALU wires 
	wire [32-1:0] A , B ;  
	reg carry , zero , negative , overflow ; 
	reg [32-1:0] alu_result ;  
	
	//Data memory wires and registers 	 
	reg [32-1:0] data_memory_out ; 
	
	
	mux4x1 mux_pc (.sel(PCsrc), .a(next_pc0), .b(next_pc1) , .c(next_pc2) , .out(pc_value));
    
	stack Stack(.data_in(St_Dout),.data_out(St_Dout), .write_en(StW), .read_en(StR), .clk(clk)); 	  
	
	InstMem inst_mem( .address(pc_value) , .Dout(inst_mem_output) );
	// IR unit
	IR IR_inst (.inst(inst_mem_output) , .inst_function(inst_function_w) , .inst_rs1(RS1) , .inst_rs2(RS2), .inst_rd(RD), .inst_type(inst_type_w) , .inst_SA(inst_SA_w) 
	            ,.imm_14(imm_14_w) , .imm_24(imm_24_w) , .stop_bit(stop_bit) );
	 //Regsiter file 		 
	 RegFile regfile(.clk(clk) , .reg_write(WB), .RA(RS1), .RB(RS2), .RW(RD), .Bus_W(WBus), .Bus_A(S1Bus) , .Bus_B(S2Bus));
	 
	 // mux 2X1 with 32 bit 
	 mux_2x1  #(32) mux_RF_src(.data0(RS2) , .data1(RD) , .sel(RS2src) , .out(inst_mem_output));	
	 
	 mux4X1 mux_ext(.sel(ExSrc) , .a(inst_SA_w) , .b(imm14_w ) , .c(imm24_w), .out(mux_ext_out)); 
	 
	 sign_extender s_extender (.in(mux_ext_out) , .signop(ExS) , .EXsrc(ExSrc) , .out(ext_out));	
	 
	 mux_2x1  #(32) mux_alu(.data0(S2Bus) , .data1(ext_out) , .sel(ALUsrc) , .out(B));
	 
	 ALU alu(.A(S1Bus) , .B(B) , .opcode(ALUop) , .result(alu_result) , .carry(carry) ,.zero(zero) , .negative(negative) ,.overflow(overflow));
	 
	 DataMem data_mem (.address(alu_result) , .Din(S2Bus) , .Dout(data_memory_out) ,.memR(MemR) , .memW(MemW) , .clk(clk)); 
	 
	 mux_2x1  #(32) mux_RF_wb(.data0(alu_result) , .data1(data_memory_out) , .sel(WBdata) , .out(WBus)); 
	 
	
	
endmodule