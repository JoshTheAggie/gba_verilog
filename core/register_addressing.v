module register_addressing(
  input wire [27:0] instruction,
  output reg [3:0] Rn, Rm, Rs
);
always@(*)
  casex(instruction[27:4])
    24'b000000XXXXXXXXXXXXXX1001: begin //multiply
      Rn = instruction[15:12];
      Rm = instruction[3:0];
      Rs = instruction[11:8];
      end
    24'b00001XXXXXXXXXXXXXXX1001: begin //multiply long
      Rn = instruction[11:8];
      Rm = instruction[3:0];
      Rs = 4'b0000;
      end
    24'b00010X00XXXXXXXX00001001: begin //single data swap
      Rn = instruction[19:16];
      Rm = instruction[3:0];
      Rs = 4'b0000;
      end
    24'b000100101111111111110001: begin //branch and exchange
      Rn = instruction[3:0];
      Rm = 4'b0000;
      Rs = 4'b0000;
      end
    24'b000XX0XXXXXXXXXX00001XX1: begin //halfword data transfer- register offset
      Rn = instruction[19:16];
      Rm = instruction[3:0];
      Rs = 4'b0000;
      end
    24'b000XX1XXXXXXXXXXXXXX1XX1: begin //halfword data transfer- immediate offset
      Rn = instruction[19:16];
      Rm = instruction[3:0];
      Rs = 4'b0000;
      end
    24'b00XXXXXXXXXXXXXXXXXXXXXX: begin //data processing/PSR xfer
      Rn = instruction[19:16];
      Rm = instruction[3:0];
      Rs = 4'b0000;
      end
    24'b01XXXXXXXXXXXXXXXXXXXXXX: begin //single data xfer
      Rn = instruction[19:16];
      Rm = 4'b0000;
      Rs = 4'b0000;
      end
    24'b011XXXXXXXXXXXXXXXXXXXX1: begin //undefined
      Rn = 4'b0000;
      Rm = 4'b0000;
      Rs = 4'b0000;
      end
    24'b100XXXXXXXXXXXXXXXXXXXXX: begin //block data xfer
      Rn = instruction[19:16];
      Rm = 4'b0000;
      Rs = 4'b0000;
      end
    24'b101XXXXXXXXXXXXXXXXXXXXX: begin //branch
      Rn = 4'bXXXX;
      Rm = 4'bXXXX;
      Rs = 4'bXXXX;
      end
    24'b1111XXXXXXXXXXXXXXXXXXXX: begin //software interrupt
      Rn = 4'bXXXX;
      Rm = 4'bXXXX;
      Rs = 4'bXXXX;
      end
    default: begin
      Rn = 4'bXXXX;
      Rm = 4'bXXXX;
      Rs = 4'bXXXX;
      end
  endcase

endmodule
