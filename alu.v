module ALU (
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [2:0]opcode , // 3 bit opcode
      output logic [31:0]result ,
      output logic carry,
      output logic zero,
      output logic negative,
      output logic overflow
  );
  
      always_comb begin
          carry = 0;
          zero = 0;
          negative = 0;
          overflow = 0;
  
          case (opcode)
              3'b000: begin // ADD
                  result = A + B;
                  carry = A[31] & B[31] | A[31] & ~result[31] | ~result[31] & B[31]; // Carry out
                  overflow = A[31] & B[31] & ~result[31] | ~A[31] & ~B[31] & result[31]; // Overflow for addition
              end
  
              3'b001: begin // SUB
                  result = A - B;
                  carry = B > A; // Borrow in subtraction is the carry here
                  overflow = ~A[31] & B[31] & result[31] | A[31] & ~B[31] & ~result[31]; // Overflow for subtraction
              end
  
              3'b010: begin // AND
                  result = A & B;
              end
  
             
  
              3'b011: begin // SLL
                  result = A << B[4:0];
              end
  
              3'b100: begin // SRL
                  result = A >> B[4:0];
              end
  
              default: begin
                  result = 0;
              end
          endcase
  
          zero = (result == 0);	 // checks if the result is equal to zero and assigns the result to the zero flag
          negative = result[31]; // MSB as sign bit
      end
  endmodule
  