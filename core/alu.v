
module alu (
    input wire [3:0] alu_op,
    input wire [31:0] input_A,
    input wire [31:0] input_B,
    input wire [31:0] input_C,
    input wire [3:0] cpsr_flags,
    input wire shiftreg_carryout,
    output reg [31:0] output_W,
    output wire [3:0] flags_out
);
    //opcodes
    localparam AND = 4'b0000; //AND
    localparam EOR = 4'b0001; //XOR
    localparam SUB = 4'b0010; //SUB
    localparam RSB = 4'b0011; //Reverse subtract 4.5
    localparam ADD = 4'b0100; //ADD
    localparam ADC = 4'b0101; //Add with carry 4.5
    localparam SBC = 4'b0110; //Sub with carry 4.5
    localparam RSC = 4'b0111; //Reverse sub with carry 4.5
    localparam TST = 4'b1000; //Test bits 4.5
    localparam TEQ = 4'b1001; //Test bitwise equality 4.5
    localparam CMP = 4'b1010; //Compare 4.5
    localparam CMN = 4'b1011; //Compare negative 4.5
    localparam ORR = 4'b1100; //OR
    localparam MOV = 4'b1101; //move reg or constant 4.5
    localparam BIC = 4'b1110; //bit clear 4.5
    localparam MVN = 4'b1111; //move negative register 4.5

    //CPSR condition flags
    reg N, Z, C, V;
    // N - negative/less than
    // Z - zero
    // C - carry/borrow/extend
    // V - overflow

    //Carry input from CPSR
    wire Carryin;
    assign Carryin = cpsr_flags[1];

    //Carryout and overflow
    reg Carryout;
    wire Overflow;
    assign Overflow = (input_A[31] == input_B[31] && input_A[31] != output_W[31]);

    always@(*)
        case(alu_op)
        AND : begin
            {Carryout, output_W} = input_A & input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        EOR : begin
            {Carryout, output_W} = input_A ^ input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        SUB : begin
            {Carryout, output_W} = input_A - input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        RSB : begin
            {Carryout, output_W} = input_B - input_A;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        ADD : begin
            {Carryout, output_W} = input_A + input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        ADC : begin
            {Carryout, output_W} = input_A + input_B + {31'b0, Carryin};
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        SBC : begin
            {Carryout, output_W} = input_A - input_B + {31'b0, Carryin} - 32'b1;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        RSC : begin
            {Carryout, output_W} = input_B - input_A + {31'b0, Carryin} - 32'b1;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        TST : begin
            {Carryout, output_W} = input_A & input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        TEQ : begin
            {Carryout, output_W} = input_A ^ input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        CMP : begin
            {Carryout, output_W} = input_A - input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        CMN : begin
            {Carryout, output_W} = input_A + input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = Carryout;
            V = Overflow;
        end
        ORR : begin
            {Carryout, output_W} = input_A | input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        MOV : begin
            {Carryout, output_W} = input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        BIC : begin
            {Carryout, output_W} = input_A & ~input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        MVN : begin
            {Carryout, output_W} = ~input_B;
            N = output_W[31];
            Z = (output_W == 32'b0);
            C = shiftreg_carryout;
            V = cpsr_flags[0];
        end
        
    endcase

    assign flags_out = {N, Z, C, V};
endmodule
