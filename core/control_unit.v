module control_unit(
    input wire [27:0] instruction,
    input wire [4:0] mode,
    input wire stall,
    output reg regDst,  //which region of the instruction denotes Rd?
                        // 0 for 15:12 (Lo),  1 for 19:16 (Hi)
    output reg MemToReg,
    output reg RegWrite,
    output reg RegWriteHi,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg LongMul,
    output reg I_flag,
    output reg S_flag,
    output reg A_flag,
    output reg U_flag,
    output reg B_flag,
    output reg P_flag,
    output reg W_flag,
    output reg L_flag,
    output reg H_flag,
    output reg Ps_flag,
    output reg [1:0] PSRwrite, // 01 for partial write (flags), 11 for full
    output reg PSRread,
    output reg [3:0] ALUOpcode,
    output reg [15:0] operand2, //12 bits for immediate/shift stuff, 16 for block xfers
    output reg block_transfer,
    output reg switchtoARM,
    output reg switchtoTHUMB,
    output reg SWI,
    output reg UNDEFINED
);

always@(*)
  if (stall) begin
      regDst = 1'b0;
      MemToReg = 1'b0;
      RegWrite = 1'b0;
      RegWriteHi = 1'b0;
      MemRead = 1'b0;
      MemWrite = 1'b0;
      Branch = 1'b0;
      LongMul = 1'b0;
      I_flag = 1'b0;
      S_flag = 1'b0;
      A_flag = 1'b0;
      U_flag = 1'b0;
      B_flag = 1'b0;
      P_flag = 1'b0;
      W_flag = 1'b0;
      L_flag = 1'b0;
      H_flag = 1'b0;
      Ps_flag = 1'b0;
      PSRwrite = 2'b0;
      PSRread = 1'b0;
      ALUOpcode = 4'b0;
      operand2 = 12'b0;
      block_transfer = 1'b0;
      switchtoARM = 1'b0;
      switchtoTHUMB = 1'b0;
      SWI = 1'b0;
      UNDEFINED = 1'b0;
  end
  else
  casex(instruction[27:4])
    24'b000000XXXXXXXXXXXXXX1001: begin //multiply
        regDst = 1'b1;
        MemToReg = 1'b0;
        RegWrite = 1'b1;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = instruction[20];
        A_flag = instruction[21];
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b00001XXXXXXXXXXXXXXX1001: begin //multiply long
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b1;
        RegWriteHi = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b1;
        I_flag = 1'b0;
        S_flag = instruction[20];
        A_flag = instruction[21];
        U_flag = instruction[22];
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b00010X00XXXXXXXX00001001: begin //single data swap
        regDst = 1'b0;
        MemToReg = 1'b1;
        RegWrite = 1'b1;
        RegWriteHi = 1'b0;
        MemRead = 1'b1;
        MemWrite = 1'b1;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = instruction[22];
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b000100101111111111110001: begin //branch and exchange
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b1;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b1;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM   = instruction[0] == 1 ? 0 : 1;
        switchtoTHUMB = instruction[0] == 1 ? 1 : 0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b000XX0XXXXXXXXXX00001XX1: begin //halfword data transfer- register offset
        regDst = 1'b0;
        MemToReg = instruction[20];
        RegWrite = instruction[20];
        RegWriteHi = 1'b0;
        MemRead = instruction[20];
        MemWrite = ~instruction[20];
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = instruction[6];
        A_flag = 1'b0;
        U_flag = instruction[23];
        B_flag = 1'b0;
        P_flag = instruction[24];
        W_flag = instruction[21];
        L_flag = instruction[20];
        H_flag = instruction[5];
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = instruction[15:0];
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b000XX1XXXXXXXXXXXXXX1XX1: begin //halfword data transfer- immediate offset
        regDst = 1'b0;
        MemToReg = instruction[20];
        RegWrite = instruction[20];
        RegWriteHi = 1'b0;
        MemRead = instruction[20];
        MemWrite = ~instruction[20];
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = instruction[6];
        A_flag = 1'b0;
        U_flag = instruction[23];
        B_flag = 1'b0;
        P_flag = instruction[24];
        W_flag = instruction[21];
        L_flag = instruction[20];
        H_flag = instruction[5];
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = instruction[15:0];
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b00010X001111XXXX00000000: begin //PSR xfer - MRS - psr to register
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b1;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = instruction[22];
        PSRwrite = 2'b0;
        PSRread = 1'b1;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b00010X101001111100000000: begin //PSR xfer - MSR - reg contents to PSR
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = instruction[22];
        PSRwrite = 2'b11; //whole PSR write
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = instruction[15:0];
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b00X10X1010001111XXXXXXXX: begin //PSR xfer - MSR - reg contents/immediate to PSR (flag bits only)
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = instruction[25];
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = instruction[22];
        PSRwrite = 2'b01; //write to just the PSR flags
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = instruction[15:0];
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end            
    24'b00XXXXXXXXXXXXXXXXXXXXXX: begin //data processing (ALU)
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b1;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = instruction[25];
        S_flag = instruction[20];
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = instruction[24:21];
        operand2 = instruction[15:0];
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b011XXXXXXXXXXXXXXXXXXXX1: begin //undefined
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM   = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b1;
        end
    24'b01XXXXXXXXXXXXXXXXXXXXXX: begin //single data xfer
        // bit 20 is L/S bit.    0=S,    1=L
        regDst = 1'b0;
        MemToReg = instruction[20];
        RegWrite = instruction[20];
        RegWriteHi = 1'b0;
        MemRead = instruction[20];
        MemWrite = ~instruction[20];
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = ~instruction[25]; //look at page 70 of datasheet(4-28). they flipped it
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = instruction[23];
        B_flag = instruction[22];
        P_flag = instruction[24];
        W_flag = instruction[21];
        L_flag = instruction[20];
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = instruction[15:0];
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b100XXXXXXXXXXXXXXXXXXXXX: begin //block data xfer
        // bit 20 is L/S bit.    0=S,    1=L
        regDst = 1'b0;
        MemToReg = instruction[20];
        RegWrite = instruction[20];
        RegWriteHi = 1'b0;
        MemRead = instruction[20];
        MemWrite = ~instruction[20];
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = instruction[22];
        A_flag = 1'b0;
        U_flag = instruction[23];
        B_flag = 1'b0;
        P_flag = instruction[24];
        W_flag = instruction[21];
        L_flag = instruction[20];
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = instruction[15:0];
        block_transfer = 1'b1;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b101XXXXXXXXXXXXXXXXXXXXX: begin //branch, branch and link
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b1;              //write new PC to PC (reg 15)
        RegWriteHi = instruction[24]; //link flag writes old PC to reg 14
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b1;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = instruction[24];
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b0;
        end
    24'b1111XXXXXXXXXXXXXXXXXXXX: begin //software interrupt
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM   = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b1;
        UNDEFINED = 1'b0;
        end
    default: begin
        regDst = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        RegWriteHi = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        Branch = 1'b0;
        LongMul = 1'b0;
        I_flag = 1'b0;
        S_flag = 1'b0;
        A_flag = 1'b0;
        U_flag = 1'b0;
        B_flag = 1'b0;
        P_flag = 1'b0;
        W_flag = 1'b0;
        L_flag = 1'b0;
        H_flag = 1'b0;
        Ps_flag = 1'b0;
        PSRwrite = 2'b0;
        PSRread = 1'b0;
        ALUOpcode = 4'bXXXX;
        operand2 = 12'b0;
        block_transfer = 1'b0;
        switchtoARM   = 1'b0;
        switchtoTHUMB = 1'b0;
        SWI = 1'b0;
        UNDEFINED = 1'b1;
        end
  endcase
endmodule