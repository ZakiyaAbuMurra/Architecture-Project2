// Code your testbench here
// or browse Examples
module tb_stack(); 
    reg clk , read_en , write_en ; 
    reg [31:0] data_in; 
    wire [31:0] data_out; 
    
    stack DUT_S(.clk(clk), 
                .read_en(read_en), 
                .write_en(write_en), 
                .data_in(data_in), 
                .data_out(data_out)
                ); 
    
    initial begin 
    clk      = 0   ; 
    read_en  = 0   ; 
    write_en = 0   ; 
    data_in  = 'h0 ; 
    end
    
    initial begin 
    forever begin 
        #3 clk <= ~clk;
    end 
    end 
    
    initial begin 
    forever begin 
        #10 read_en <= $urandom_range(0,1); 
        #30 write_en <= $urandom_range(0,1); 
        #20 data_in <= $urandom_range(0,255); 
    end 
    end 
    
    initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
    #1000 
    $finish ; 
    end  
    
    
    
    
    
    
  endmodule 