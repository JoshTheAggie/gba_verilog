module multiplier (
    input wire A_flag,
    input wire U_flag,
    input wire LongMul,
    input wire [31:0] Rm_data,
    input wire [31:0] Rs_data,
    input wire [31:0] Rn_data,
    input wire [31:0] RdHi_data, //used for MLAL instructions...
    input wire [31:0] RdLo_data,
    input wire [3:0] cpsr_flags,
    output wire [31:0] result_lo,
    output wire [31:0] result_hi,
    output wire [3:0] flags_out
);
//CPSR condition flags
wire N, Z, C, V;
// N - negative/less than
// Z - zero
// C - carry/borrow/extend
// V - overflow
assign N = LongMul ? result_hi[31] : result_lo[31];
assign Z = LongMul ? ~|{result_hi, result_lo} : ~|result_lo;
assign C = productHi[0]; //meaningless
assign V = cpsr_flags[0]; //unaffected
assign flags_out = {N, Z, C, V};

wire [31:0] productHi, productLo;

//multiplication step

assign {productHi, productLo} = (U_flag & LongMul) ? $signed(Rm_data) * $signed(Rs_data) :
                                                    $unsigned(Rm_data) * $unsigned(Rs_data);

assign {result_hi, result_lo} = A_flag   ?
                                (LongMul ? ({productHi, productLo} + {RdHi_data, RdLo_data}) :
                                ({productHi, productLo} + Rn_data)) :
                                {productHi, productLo};

endmodule