module CPU(clk, inst_Din);
	input clk;
	input [31:0] inst_Din;
	
	wire [31:0] next_pc0, next_pc1, next_pc2;
	wire [31:0] pc_value; 
	wire [1:0] inst_type ; 
	wire [1:0] [4:0] inst_function; 
	wire stop_bit, zero_flag; 
	wire ExSrc, ExS, RS2src, WB, MemR, MemW, WBdata, PCaddSrc1, PCaddSrc2, ALUsrc, StR, StW;
	wire [1:0] PCsrc ; 
	wire [3:0] ALUop; 
	wire [2:0] next_state; 
	
    //stack wires 
	wire [31:0] St_Din; 
	wire [31:0] St_Dout; 
	// instruction memory wires 
	wire inst_memW;  
	
	//IR wires 
	wire [5-1:0] RS1 ; 
	wire [5-1:0] RS2 ;	 
	wire [5-1:0] RD  ; 
	wire [32-1:0] S1Bus ; 
	wire [32-1:0] S2Bus ; 
	wire [32-1:0] WBus  ; 	
	
	//extender wires 
	wire [5-1:0] shift_amm; 
	wire 
	
	
	
	
	mux4x1 mux_pc (.sel(PCsrc), .a(next_pc0), .b(next_pc1) , .c(next_pc2) , .out(pc_value));
    
	stack Stack(.data_in(St_Dout),.data_out(St_Dout), .write_en(StW), .read_en(StR), .clk(clk)); 	  
	
	 // to do : Din ? 
	 InstMem inst_mem(.memW(inst_memW) .address(pc_value), .Din() , .Dout() ); 
	
	 // IR unit 
	 
	 //Regsiter file 		 
	 RegFile regfile(.clk(clk) , .reg_write(WB), .RA(RS1), .RB(RS2), .RW(RD), .Bus_W(WBus), .Bus_A(S1Bus) , .Bus_B(S2Bus));
	 
	 // mux 2X1 with 32 bit 
	 mux_2x1 mux_alu #(32)(.data0(RS2) , .data1() , .sel() , .out());
	 
	
	
	
endmodule