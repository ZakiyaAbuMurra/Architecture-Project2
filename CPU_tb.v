module CPU_tb() ; 
	
 reg clk ; 
 reg  [31:0] inst_Din; 
 
 CPU dut(.clk(clk) , .inst_Din(inst_Din));	 
 
 initial begin 
	 clk =0 ; 
	 inst_Din =0 ; 
 end 
 
 initial begin 
 forever begin 
	 #3 clk <= ~clk ; 
	 #3 inst_Din <= 32'hf; 
	 end 
  end 
  
    initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #10000
    $finish ; 
    end  
	
	
endmodule 