
module alu (
    input [3:0] alu_op,
    input [31:0] input_A,
    input [31:0] input_B,
    input [31:0] input_C,
    output [31:0] output_W,
    output is_zero,
    output is_lessthan
);
    //opcodes
    localparam AND = 4'b0000;
    localparam EOR = 4'b0001;
    localparam SUB = 4'b0010;
    localparam RSB = 4'b0011;
    localparam ADD = 4'b0100;
    localparam ADC = 4'b0101;
    localparam SBC = 4'b0110;
    localparam RSC = 4'b0111;
    localparam TST = 4'b1000;
    localparam TEQ = 4'b1001;
    localparam CMP = 4'b1010;
    localparam CMN = 4'b1011;
    localparam ORR = 4'b1100;
    localparam MOV = 4'b1101;
    localparam BIC = 4'b1110;
    localparam MVN = 4'b1111;

endmodule
